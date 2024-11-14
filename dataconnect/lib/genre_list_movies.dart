import 'package:dataconnect/movies_connector/movies.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GenreListMovies extends StatefulWidget {
  const GenreListMovies({super.key, required this.genre});
  final String genre;

  @override
  State<GenreListMovies> createState() => _GenreListMoviesState();
}

class _GenreListMoviesState extends State<GenreListMovies> {
  bool loading = true;
  List<ListMoviesByGenreMovies> _mostPopular = [];
  List<ListMoviesByGenreMovies> _mostRecent = [];

  void _visitDetail(String id) {
    context.push("/movies/$id");
  }

  Widget _buildMovieList(String title, List<ListMoviesByGenreMovies> movies) {
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

  Widget _buildMovieItem(ListMoviesByGenreMovies movie) {
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

  @override
  void initState() {
    super.initState();
    String genre = widget.genre;
    MoviesConnector.instance
        .listMoviesByGenre(genre: genre)
        .orderByRating(OrderDirection.DESC)
        .limit(10)
        .execute()
        .then((res) {
      setState(() {
        _mostPopular = res.data.movies;
      });
    });

    MoviesConnector.instance
        .listMoviesByGenre(genre: genre)
        .orderByReleaseYear(OrderDirection.DESC)
        .execute()
        .then((res) {
      setState(() {
        _mostRecent = res.data.movies;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: _mostPopular.isEmpty && _mostRecent.isEmpty
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [CircularProgressIndicator()],
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Text(
                        "${widget.genre} Movies",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      _buildMovieList("Most Popular", _mostPopular),
                      _buildMovieList("Most Recent", _mostRecent)
                    ],
                  ),
                )),
    );
  }
}
