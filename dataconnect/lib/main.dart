import 'dart:async';

import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'movie_detail.dart';
import 'movies_connector/movies.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MyHomePage(),
    ),
    GoRoute(
      path: '/movies/:movieId',
      builder: (context, state) =>
          MovieDetail(id: state.pathParameters['movieId']!),
    )
  ],
  redirect: (context, state) {
    print(state.path);
    return null;
  },
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.dark(),
      routerConfig: _router,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ListMoviesMovies> _topMovies = [];
  List<ListMoviesMovies> _latestMovies = [];

  @override
  void initState() {
    super.initState();

    /// TODO: Uncomment the following lines to update the movies state when data
    /// comes back from the server.
    MoviesConnector.instance.dataConnect
        .useDataConnectEmulator('localhost', 9399);
    MoviesConnector.instance
        .listMovies()
        .orderByRating(OrderDirection.DESC)
        .limit(10)
        .execute()
        .then((res) {
      setState(() {
        _topMovies = res.data.movies;
      });
    });

    MoviesConnector.instance
        .listMovies()
        .orderByReleaseYear(OrderDirection.DESC)
        .execute()
        .then((res) {
      setState(() {
        _latestMovies = res.data.movies;
      });
    });
  }

  void _refreshData() {
    // Gets the data, then notifies the subscriber(s) of the new data.
    // TODO: Uncomment the following line to execute the query
    // MoviesConnector.instance.listMovies.ref().build().execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildMovieList('Top 10 Movies', _topMovies),
            _buildMovieList('Latest Movies', _latestMovies),
          ],
        ),
      )),
    );
  }

  Widget _buildMovieList(String title, List<ListMoviesMovies> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 300, // Adjust the height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return _buildMovieItem(movies[index]);
            },
          ),
        ),
      ],
    );
  }

  void _visitDetail(String id) {
    context.push("/movies/$id");
  }

  Widget _buildMovieItem(ListMoviesMovies movie) {
    return Container(
      width: 150, // Adjust the width as needed
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: InkWell(
            onTap: () {
              _visitDetail(movie.id);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 9 / 16, // 9:16 aspect ratio for the image
                  child: Image.network(
                    movie.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    movie.title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
