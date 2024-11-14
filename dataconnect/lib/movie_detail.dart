import 'package:dataconnect/movies_connector/movies.dart';
import 'package:dataconnect/widgets/login_guard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MovieDetail extends StatefulWidget {
  const MovieDetail({super.key, required this.id});

  final String id;

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  double _ratingValue = 0;
  String _reviewText = "";
  bool loading = true;
  GetMovieByIdData? data;
  bool _watched = false;
  bool _favorited = false;

  TextEditingController _reviewTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    MoviesConnector.instance
        .getMovieById(id: widget.id)
        .ref()
        .subscribe()
        .listen((value) {
      setState(() {
        loading = false;
        data = value.data;
      });
    });
    MoviesConnector.instance
        .getMovieInfoForUser(movieId: widget.id)
        .ref()
        .subscribe()
        .listen((value) {
      setState(() {
        _watched = value.data.watched_movie != null;
        _favorited = value.data.favorite_movie != null;
      });
    });
  }

  void _refreshData() {
    MoviesConnector.instance.getMovieById(id: widget.id).execute();
    MoviesConnector.instance.getMovieInfoForUser(movieId: widget.id).execute();
  }

  List<Widget> _buildMainDescription() {
    var movie = data!.movie!;
    return [
      Align(
          alignment: Alignment.centerLeft,
          child: Container(
            child: Text(
              movie.title,
              style: const TextStyle(fontSize: 30),
            ),
          )),
      Row(
        children: [
          Text(movie.releaseYear.toString()),
          const SizedBox(width: 10),
          Row(
            children: [const Icon(Icons.star), Text(movie.rating.toString())],
          )
        ],
      ),
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 9 / 16, // 9:16 aspect ratio for the image
                child: Image.network(
                  movie.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Column(children: [
                Row(
                  children: movie.tags!.map((tag) {
                    return TextButton(onPressed: () {}, child: Text(tag));
                  }).toList(),
                ),
                Text(movie.description!)
              ]),
            ))
          ]),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LoginGuard(
              widgetToGuard: OutlinedButton.icon(
            onPressed: () {
              (_watched
                      ? MoviesConnector.instance
                          .deleteFavoritedMovie(movieId: widget.id)
                          .execute()
                      : MoviesConnector.instance
                          .addFavoritedMovie(movieId: widget.id)
                          .execute())
                  .then(
                (value) => setState(() {
                  _watched = !_watched;
                }),
              );
            },
            icon: Icon(
                _watched ? Icons.check_circle : Icons.check_circle_outline),
            label: const Text('Watched'),
          )),
          LoginGuard(
              widgetToGuard: OutlinedButton.icon(
            onPressed: () {
              (_favorited
                      ? MoviesConnector.instance
                          .deleteFavoritedMovie(movieId: widget.id)
                          .execute()
                      : MoviesConnector.instance
                          .addFavoritedMovie(movieId: widget.id)
                          .execute())
                  .then((value) {
                setState(() {
                  _favorited = !_favorited;
                });
              });
            },
            icon: Icon(_favorited ? Icons.favorite : Icons.favorite_border),
            label: const Text('Add To Favorites'),
          ))
        ],
      )
    ];
  }

  void _visitActorDetail(String id) {
    context.push("/actors/$id");
  }

  Widget _buildMainActorsList() {
    return Container(
        height: 125,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Main Actors",
              style: TextStyle(fontSize: 30),
            ),
            Expanded(
                child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                GetMovieByIdMovieMainActors actor =
                    data!.movie!.mainActors[index];
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                          radius: 30,
                          child:
                              ClipOval(child: Image.network(actor.imageUrl))),
                      Text(actor
                          .name) // TODO(mtewani): Clip if there's not enough width
                    ]);
              },
              itemCount: data!.movie!.mainActors.length,
            ))
          ],
        ));
  }

  Widget _buildSupportingActorsList() {
    return Container(
        height: 125,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Supporting Actors",
              style: TextStyle(fontSize: 30),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  GetMovieByIdMovieSupportingActors actor =
                      data!.movie!.supportingActors[index];
                  return InkWell(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                              radius: 30,
                              child: ClipOval(
                                  child: Image.network(actor.imageUrl))),
                          Text(actor
                              .name) // TODO(mtewani): Clip if there's not enough width
                        ]),
                    onTap: () {
                      _visitActorDetail(actor.id);
                    },
                  );
                },
                itemCount: data!.movie!.mainActors.length,
              ),
            )
          ],
        ));
  }

  List<Widget> _buildRatings() {
    return [
      Text("Rating: $_ratingValue"),
      Slider(
        value: _ratingValue,
        max: 10,
        divisions: 20,
        label: _ratingValue.toString(),
        onChanged: (double value) {
          setState(() {
            _ratingValue = value;
          });
        },
      ),
      LoginGuard(
          widgetToGuard: TextField(
            decoration: const InputDecoration(
              hintText: "Write your review",
              border: OutlineInputBorder(),
            ),
            controller: _reviewTextController,
          ),
          message: "writing a review"),
      LoginGuard(
        widgetToGuard: OutlinedButton.icon(
          onPressed: () {
            // TODO(mtewani): Check if user is logged in.
            MoviesConnector.instance
                .addReview(
                    movieId: widget.id,
                    rating: _ratingValue.toInt(),
                    reviewText: _reviewTextController.text)
                .execute()
                .then((_) {
              _refreshData();
              _reviewTextController.clear();
            });
          },
          label: const Text('Submit Review'),
        ),
      ),
      ...data!.movie!.reviews.map((review) {
        return Card(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review.user.username),
                  Row(
                    children: [
                      Text(DateFormat.yMMMd().format(review.reviewDate)),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("Rating ${review.rating}")
                    ],
                  ),
                  Text(review.reviewText!)
                ],
              )),
        );
      })
    ];
/**/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: data == null
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [CircularProgressIndicator()],
                )
              : Padding(
                  padding: const EdgeInsets.all(30),
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      ..._buildMainDescription(),
                      _buildMainActorsList(),
                      _buildSupportingActorsList(),
                      ..._buildRatings()
                    ],
                  )))),
    );
  }
}
