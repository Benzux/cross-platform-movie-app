import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];
  String currentTitle = "a";

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
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ODY1OWI4NThjMGM4YjkwN2UwZDU4MDE1YzllYWIwYSIsIm5iZiI6MTc0MDYzNzg0NS41MjQsInN1YiI6IjY3YzAwNjk1YzE1M2VjZTJlMmEyMmY0OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.AQ2zUonoogkh0jqdveCOcYIKuu-obuwVNVgxBECwY0A",
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
    );

    print(response.body);

    // Extracting the title of a movie to show in the UI
    var data = jsonDecode(response.body) as Map<String, dynamic>;

    List movies = data["results"];

    List<String> titles = movies.map((movie){
      return movie["original_title"] as String;
    }).toList();

    currentTitle = titles.first;
    notifyListeners();
  }
}