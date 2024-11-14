import 'package:dataconnect/movies_connector/movies.dart';
import 'package:flutter/material.dart';

class ActorDetail extends StatefulWidget {
  const ActorDetail({super.key, required this.actorId});

  final String actorId;

  @override
  State<ActorDetail> createState() => _ActorDetailState();
}

class _ActorDetailState extends State<ActorDetail> {
  bool loading = true;
  GetActorByIdActor? actor;
  @override
  void initState() {
    super.initState();
    MoviesConnector.instance
        .getActorById(id: widget.actorId)
        .execute()
        .then((value) {
      setState(() {
        loading = false;
        actor = value.data.actor;
      });
    });
  }

  _buildActorInfo() {
    return [
      Align(
          alignment: Alignment.centerLeft,
          child: Container(
            child: Text(
              actor!.name,
              style: const TextStyle(fontSize: 30),
            ),
          )),
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 9 / 16, // 9:16 aspect ratio for the image
                child: Image.network(
                  actor!.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              // child: Column(children: [Text(actor!.info!)]),
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
            icon: const Icon(Icons.favorite),
            label: const Text('Add To Favorites'),
          )
        ],
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: actor == null
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [CircularProgressIndicator()],
                )
              : Padding(
                  padding: const EdgeInsets.all(30),
                  child: SingleChildScrollView(
                      child: Column(
                    children: [..._buildActorInfo()],
                  )))),
    );
  }
}
