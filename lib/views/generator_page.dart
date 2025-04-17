import 'package:flutter/material.dart';
import 'package:movie_app/main.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/providers/app_state.dart';
import 'package:movie_app/providers/movieapp.dart';
import 'package:provider/provider.dart';

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var movieApp = context.read<MovieAppProvider>();

    List<Movie> movies = appState.movies;
    //var pair = appState.current;
    String currentTitle = appState.currentTitle;

    // Changing the icon of the "like" button when it is clicked
    /*IconData icon;
    if (appState.favourites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }*/

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Expanded(flex: 3, child: HistoryListView(),),
          // Showing the title of a movie pulled from the API in the UI
          Text(currentTitle),
          TextButton(onPressed: movieApp.send, child: Text("GRPC test")),
          TextButton(onPressed: appState.getPopularMovies, child: Text("Get popular moives")),
          //Spacer(flex: 2),
          SizedBox(
            height: 300,
            child: ListView.builder(itemBuilder: (context, index) {
              var image = Image.network(
                "https://image.tmdb.org/t/p/w500${movies[index].posterPath}"
                );
              return ListTile(title: Text(movies[index].originalTitle));
            }, itemCount: movies.length,
            ),
            ),
          //NameCard(pair: pair),
          /*SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavourite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),*/
        
        ],
      ),
    );
  }
}
