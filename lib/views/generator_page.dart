import 'package:flutter/material.dart';
import 'package:movie_app/main.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/providers/app_state.dart';
import 'package:movie_app/providers/movieapp.dart';
import 'package:movie_app/widgets/swipeable_cards.dart';
import 'package:provider/provider.dart';

class GeneratorPage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var movieState = context.watch<MovieAppProvider>();
    //var movieApp = context.read<MovieAppProvider>();

    //List<Movie> movies = appState.movies;
    //var pair = appState.current;
    //String currentTitle = appState.currentTitle;

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
          //Text(currentTitle),
          //TextButton(onPressed: movieApp.send, child: Text("GRPC test")),
          //TextButton(onPressed: appState.getPopularMovies, child: Text("Get popular moives")),
          //Spacer(flex: 2),
          FutureBuilder<List<Movie>>(
            future: appState.getPopularMovies(), builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.connectionState == ConnectionState.done && !snapshot.hasError && snapshot.hasData) {
              return SwipeableCards(snapshot.data!);
            }

            return Text("No movies found");
          }),
          Text("${movieState.userName}"),
          TextFormField(controller: controller),
          TextButton(onPressed: (){ 
            print("${controller.text}");
            movieState.setUserName(controller.text);
            }, 
          child: Text("Save username"))
          
          /*SizedBox(
            height: 300,
            child: ListView.builder(itemBuilder: (context, index) {
              var image = Image.network(
                "https://image.tmdb.org/t/p/w500${movies[index].posterPath}"
                );
              return ListTile(title: Text(movies[index].originalTitle));
            }, itemCount: movies.length,
            ),
            ),*/
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
