import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/movie.dart';

class MyAppState extends ChangeNotifier {
  List<Movie> movies = [];
  var current = WordPair.random();
  var history = <WordPair>[];
  String currentTitle = "a";
  late final String readAccessKey;

  MyAppState() {
    String? key = dotenv.env["TMDB_READ_ACCESS_KEY"];
    if (key == null) {
      throw Exception("No read access key found in app_state init, does .env exist?");
    }
    readAccessKey = key;
  }
  

  GlobalKey? historyListKey;

  // Generate a new compound word and add the previous one to the history
  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  var favourites = <WordPair>[];

  // Toggle a word between being favourited or not favourited
  void toggleFavourite([WordPair? pair]) {
    pair = pair ?? current;
    if (favourites.contains(pair)) {
      favourites.remove(pair);
    } else {
      favourites.add(pair);
    }
    notifyListeners();
  }

  // Function used for getting info about movies from the API
  Future<void> getPopularMovies() async {
    final Uri url = Uri.parse("https://api.themoviedb.org/3/movie/popular");

    var response = await http.get(
      url, 
      headers: {
        "Authorization": "Bearer $readAccessKey",
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
    );

    print(response.body);

    // Extracting the title of a movie to show in the UI
    var data = jsonDecode(response.body) as Map<String, dynamic>;

    List moviesJson = data["results"];

    movies = moviesJson.map((moviesJson) => Movie.fromJson(moviesJson)).toList();

    /*List<String> titles = movies.map((movie){
      return movie["original_title"] as String;
    }).toList();

    print(titles);
    currentTitle = titles.first;*/
    notifyListeners();
  }
}