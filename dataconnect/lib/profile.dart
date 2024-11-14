import 'package:dataconnect/extensions.dart';
import 'package:dataconnect/main.dart';
import 'package:dataconnect/movies_connector/movies.dart';
import 'package:dataconnect/util/auth.dart';
import 'package:dataconnect/widgets/list_movies.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? _currentUser;
  List<GetCurrentUserUserFavoriteMoviesMovie> _favoriteMovies = [];
  List<GetCurrentUserUserFavoriteActors> _favoriteActors = [];
  List<GetCurrentUserUserWatchedMoviesMovie> _watchedMovies = [];
  String? _displayName;
  @override
  void initState() {
    super.initState();
    Auth.getCurrentUser().then((user) {
      setState(() {
        _currentUser = user;
      });
    });
    MoviesConnector.instance.getCurrentUser().execute().then((res) {
      setState(() {
        _displayName = res.data.user!.name;
        _favoriteMovies =
            res.data.user!.favoriteMovies.map((e) => e.movie).toList();
        _favoriteActors = res.data.user!.favoriteActors;
        _watchedMovies =
            res.data.user!.watchedMovies.map((e) => e.movie).toList();
      });
    });
  }

  Widget _UserInfo() {
    return Container(
      child: Column(
        children: [
          Text('Welcome back ${_currentUser!.displayName ?? ''}!'),
          TextButton(
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                context.go('/login');
              },
              child: Text('Sign out'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _currentUser == null
        ? const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [CircularProgressIndicator()],
          )
        : SingleChildScrollView(
            child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _UserInfo(),
                ListMovies(
                    title: "Watched Movies",
                    movies: _watchedMovies
                        .map(
                          (e) => e.toListMoviesMovies,
                        )
                        .toList()),
                ListMovies(
                    title: "Favorite Movies",
                    movies: _favoriteMovies
                        .map(
                          (e) => e.toListMoviesMovies,
                        )
                        .toList())
              ],
            ),
          ));
  }
}
