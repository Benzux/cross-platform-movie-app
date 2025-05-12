import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:movie_app/providers/movieapp.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';

class SwipeableCards extends StatelessWidget {
  final List<Movie> movies;
  SwipeableCards(this.movies);
  @override
  Widget build(BuildContext context) {

    /*var appState = context.watch<MyAppState>();

    var movies = appState.movies;*/

    var movieApp = context.read<MovieAppProvider>();

    if(movies.isEmpty){
      return Text("No movies available");
    }

    return Flexible(
        child: CardSwiper(
            cardBuilder: (context, index, tresholdX, tresholdY) {

              var baseUrl = "https://image.tmdb.org/t/p/w500"; 
              var posterPath = movies[index].posterPath;
              var fullImageUrl = baseUrl + posterPath;


              return Container(
                alignment: Alignment.center,
                child: Image.network(fullImageUrl),
              );


             
            },
            cardsCount: movies.length,
            onSwipe: (oldIndex, currentIndex, direction) {
              print("$oldIndex $currentIndex $direction");
              if (direction == CardSwiperDirection.right) {
                movieApp.send(movies[oldIndex].originalTitle);
              }
              return true;
            },
            isLoop: false,
            allowedSwipeDirection: AllowedSwipeDirection.only(
              left: true,
              right: true,
            ),
            ));
  }
}