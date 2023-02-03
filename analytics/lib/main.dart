import 'package:analytics_quickstart/selection_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: (context, child) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Firebase Analytics Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Consumer<ApplicationState>(
          builder: (context, appState, _) => Column(
            children: <Widget>[
              // Title(
              //   color: Colors.orange,
              //   child: const Text(
              //     'Firebase Analytics',
              //   ),
              // ),
              const Text(
                'Interact with the various controls to start collecting analytics data.',
              ),
              const Text(
                'Set user properties',
              ),
              seasonSelector(appState),
              preferredTempSelector(appState),
              const Text('Log user interactions with events'),
              hotOrColdSelector(appState),
              rainOrSunshineSelector(appState),
              preferredTemperatureSelector(appState),
            ],
          ),
        ),
      ),
    );
  }
}
