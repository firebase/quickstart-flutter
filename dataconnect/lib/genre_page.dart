import 'package:dataconnect/movies_connector/movies.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GenrePage extends StatefulWidget {
  const GenrePage({super.key});

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  List<String> genres = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    MoviesConnector.instance.listGenres().execute().then((genres) {
      setState(() {
        loading = false;
        this.genres =
            genres.data.genres.map((genreData) => genreData.genre!).toList();
      });
    });
  }

  Widget _buildGenreList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        String genre = genres[index];
        return ListTile(
          title: TextButton(
            child: Text(genre, style: TextStyle(fontSize: 30)),
            onPressed: () {
              context.push('/genres/${genre}');
            },
          ),
        );
      },
      itemCount: genres.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: loading
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [CircularProgressIndicator()],
                )
              : Padding(
                  padding: const EdgeInsets.all(30), child: _buildGenreList()
                  // ..._buildMainDescription(),
                  // _buildMainActorsList(),
                  // _buildSupportingActorsList(),
                  // ..._buildRatings()
                  )),
    );
  }
}
