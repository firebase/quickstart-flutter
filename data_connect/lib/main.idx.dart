import 'package:dataconnect/models/movie.dart';
import 'package:dataconnect/movie_state.dart';
import 'package:dataconnect/router.dart';
import 'package:dataconnect/widgets/list_movies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'util/auth.dart';
import 'movies_connector/movies.dart';

bool isSetup = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    isSetup = true;

    await Auth.instance.init();
    int port = 443;
    String hostName = Uri.base.host;
    bool isSecure = true;
    if (!kIsWeb) {
      hostName = '10.0.2.2';
      port = 9403;
      isSecure = false;
    }
    MoviesConnector.instance.dataConnect
        .useDataConnectEmulator(hostName, port, isSecure: isSecure);
  } catch (_) {
    // The user hasn't run ./installDeps.sh yet
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.dark(),
      routerConfig: router,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ListMoviesMovies> _topMovies = [];
  List<ListMoviesMovies> _latestMovies = [];
  bool _showMessage = true;

  @override
  void initState() {
    super.initState();

    if (isSetup) {
      MovieState.getTopTenMovies().then((res) {
        if (res.data.movies.isNotEmpty) {
          if (mounted) {
            setState(() {
              _showMessage = false;
              _topMovies = res.data.movies;
            });
          }
        }
      });

      MovieState.getTopTenMovies().then((res) {
        setState(() {
          _latestMovies = res.data.movies;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: _showMessage || !isSetup
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: isSetup
                          ? Text(
                              'Go to the Firebase Data Connect extension, and click start Emulators. ${_latestMovies.isEmpty ? 'Then open dataconnect/moviedata_insert.gql and the click "Run(local)".' : ''}  Then, refresh the page.')
                          : const NumberedList(bullets: [
                              'Make sure you already have a Firebase Project',
                              'In the sidebar, open The Firebase Data Connect Extension',
                              'Sign into your google account associated with your firebase project',
                              'Select your firebase project',
                              'Open a new terminal (by clicking the + icon below) and Run "flutterfire configure -y -a com.example.dataconnect"',
                              'Refresh this preview page'
                            ]))
                ],
              ))
            : Column(
                children: <Widget>[
                  ListMovies(
                      title: 'Top 10 Movies',
                      movies: _topMovies
                          .map(
                            (e) => Movie(
                                id: e.id,
                                title: e.title,
                                imageUrl: e.imageUrl,
                                description: e.description),
                          )
                          .toList()),
                  ListMovies(
                      title: 'Latest Movies',
                      movies: _latestMovies
                          .map(
                            (e) => Movie(
                                id: e.id,
                                title: e.title,
                                imageUrl: e.imageUrl,
                                description: e.description),
                          )
                          .toList()),
                ],
              ),
      )),
    );
  }
}

class NumberedList extends StatelessWidget {
  const NumberedList({super.key, required this.bullets});

  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
        child: Column(
            children: bullets
                .asMap()
                .keys
                .map((index) => Row(children: [
                      Text(
                        "${index + 1}.",
                        style: const TextStyle(
                            fontSize: 16, height: 1.55, color: Colors.white),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          bullets[index],
                          textAlign: TextAlign.left,
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.55,
                          ),
                        ),
                      )
                    ]))
                .toList()));
  }
}
