import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Get Remote Config instance.
  final remoteConfig = FirebaseRemoteConfig.instance;

  // Create a Remote Config Setting to enable developer mode, which you can use to increase
  // the number of fetches available per hour during development. Also use Remote Config
  // Setting to set the minimum fetch interval.
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 1),
    minimumFetchInterval: const Duration(seconds: 1),
  ));

  // Set default Remote Config parameter values. An app uses the in-app default values, and
  // when you need to adjust those defaults, you set an updated value for only the values you
  // want to change in the Firebase console. See Best Practices in the README for more
  // information.
  remoteConfig.setDefaults(const {
    "averageUserGeneration": "Millennial",
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote Config Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Remote Config Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isFetching = false;

  @override
  Widget build(BuildContext context) {
    final avgGeneration =
        FirebaseRemoteConfig.instance.getString("averageUserGeneration");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (avgGeneration == "Millennial")
              const Text('Welcome to this application.'),
            if (avgGeneration == "Gen Z")
              SizedBox(
                child: Image.asset("assets/how_do_you_do_fellow_kids.jpeg"),
              ),
            const Divider(),
            if (!_isFetching)
              ElevatedButton(
                onPressed: () async {
                  setState(() => _isFetching = true);
                  await FirebaseRemoteConfig.instance.fetchAndActivate();
                  setState(() => _isFetching = false);
                },
                child: const Text('Check for new config'),
              ),
            if (_isFetching) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
