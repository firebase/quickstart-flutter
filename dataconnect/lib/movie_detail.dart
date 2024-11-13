import 'package:dataconnect/movies_connector/movies.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MovieDetail extends StatefulWidget {
  const MovieDetail({super.key, required this.id});

  final String id;

  @override
  State<MovieDetail> createState() => _MovieDetailState(id: this.id);
}

class _MovieDetailState extends State<MovieDetail> {
  _MovieDetailState({required this.id});
  String id;
  double _ratingValue = 0;
  bool loading = true;
  GetMovieByIdData? data;
  @override
  void initState() {
    super.initState();
    MoviesConnector.instance.getMovieById(id: id).execute().then((value) {
      setState(() {
        loading = false;
        data = value.data;
      });
    });
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
          // TODO(mtewani): Check if the movie has been watched by the user
          OutlinedButton.icon(
            onPressed: () {
              // TODO(mtewani): Check if user is logged in.
            },
            icon: const Icon(Icons.check_circle),
            label: const Text('Watched'),
          ),
          OutlinedButton.icon(
            onPressed: () {
              // TODO(mtewani): Check if user is logged in.
            },
            icon: const Icon(Icons.favorite),
            label: const Text('Add To Favorites'),
          )
        ],
      )
    ];
  }

  Widget _buildMainActorsList() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Main Actors",
          style: TextStyle(fontSize: 30),
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            GetMovieByIdMovieMainActors actor = data!.movie!.mainActors[index];
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      radius: 30,
                      child: ClipOval(child: Image.network(actor.imageUrl))),
                  Text(actor
                      .name) // TODO(mtewani): Clip if there's not enough width
                ]);
          },
          itemCount: data!.movie!.mainActors.length,
        )
      ],
    ));
  }

  Widget _buildSupportingActorsList() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Supporting Actors",
          style: TextStyle(fontSize: 30),
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            GetMovieByIdMovieSupportingActors actor =
                data!.movie!.supportingActors[index];
            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      radius: 30,
                      child: ClipOval(child: Image.network(actor.imageUrl))),
                  Text(actor
                      .name) // TODO(mtewani): Clip if there's not enough width
                ]);
          },
          itemCount: data!.movie!.mainActors.length,
        )
      ],
    ));
  }

  List<Widget> _buildRatings() {
    return [
      Text("Rating: $_ratingValue"),
      Slider(
        value: _ratingValue,
        max: 5,
        divisions: 10,
        label: _ratingValue.toString(),
        onChanged: (double value) {
          setState(() {
            _ratingValue = value;
          });
        },
      ),
      TextField(
        decoration: InputDecoration(
          hintText: "Write your review",
          border: OutlineInputBorder(),
        ),
      ),
      OutlinedButton.icon(
        onPressed: () {
          // TODO(mtewani): Check if user is logged in.
        },
        label: const Text('Submit Review'),
      ),
      ...data!.movie!.reviews.map((review) {
        return Card(
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review.user.username),
                  Row(
                    children: [
                      Text(DateFormat.yMMMd().format(review.reviewDate)),
                      SizedBox(
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
