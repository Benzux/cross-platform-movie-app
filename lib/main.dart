import 'dart:io';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/providers/app_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

Future<void> main() async {

  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=> MyAppState())
    ],
    child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Movie App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 109, 0, 199)),
      ),
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: "/", 
            builder: (context, state) {
              return MyHomePage(
                GeneratorPage()
              );
            },
          ),
          GoRoute(
            path: "/favourites", 
            builder: (context, state) {
              return MyHomePage(
                FavouritesPage()
              );
            },
          )
        ]
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Widget? child;
  const MyHomePage(this.child);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Navigation between the app's pages
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    if (Platform.isAndroid) {
      return Scaffold(body: CustomNavigationRail(widget: widget));
    }

    /*if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar.large(largeTitle: Text("Test")),
        child: Text("test"),
      );
    }*/
    return Container();
  }
}

class CustomNavigationRail extends StatelessWidget {
  const CustomNavigationRail({super.key, required this.widget});

  final MyHomePage widget;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: GestureDetector(
                        child: Icon(Icons.home),
                        onTap: () => context.go("/"),
                      ),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: GestureDetector(
                        child: Icon(Icons.favorite),
                        onTap: () => context.go("/favourites"),
                        ),
                      label: Text('Favourites'),
                    ),
                  ],
                  selectedIndex: null,
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: widget.child,
                ),
              ),
            ],
          );
        }
    );
  }
}

// The "frontpage", where we generate word pairs
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    String currentTitle = appState.currentTitle;

    // Changing the icon of the "like" button when it is clicked
    IconData icon;
    if (appState.favourites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 3, child: HistoryListView(),),
          SizedBox(height: 10),
          NameCard(pair: pair),
          SizedBox(height: 10),
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
          ),
          // Showing the title of a movie pulled from the API in the UI
          Text(currentTitle),
          TextButton(onPressed: appState.getPopularMovies, child: Text("Get movie title")),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}

// Page where favourited words are shown in a list format
class FavouritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favourites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }
    
    return ListView(
      children: [
        Padding(padding: const EdgeInsets.all(20),
        child: Text("You have ${appState.favourites.length} favourites: "),
        ),
        for (var fave in appState.favourites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(fave.asPascalCase)
          )
      ]
    );
  }
}

// Card that contains the generated compound word
class NameCard extends StatelessWidget {
  const NameCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asPascalCase, 
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
          ),
      ),
    );
  }
}

// Showing the history of generated words in the UI
// Taken from the advanced example found through the "Write Your First App" Docs
class HistoryListView extends StatefulWidget {
  const HistoryListView({super.key});

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  final _key = GlobalKey();

  static const Gradient _maskingGradient = LinearGradient(
    colors: [Colors.transparent, Colors.black],
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: EdgeInsets.only(top: 100),
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final pair = appState.history[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  appState.toggleFavourite(pair);
                },
                icon: appState.favourites.contains(pair)
                    ? Icon(Icons.favorite, size: 12)
                    : SizedBox(),
                label: Text(
                  pair.asLowerCase,
                  semanticsLabel: pair.asPascalCase,
                ), 
              ),
            ),
          );
        },
      ),
    );
  }
}