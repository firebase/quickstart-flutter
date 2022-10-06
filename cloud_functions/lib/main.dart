import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFunctions.instance.useFunctionsEmulator("localhost", 5001);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final _controller = TextEditingController();
  String _response = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Enter a message',
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                FirebaseFunctions.instance
                    .httpsCallable(
                  'callablevtwo',
                  options: HttpsCallableOptions(
                    timeout: const Duration(
                      seconds: 60,
                    ),
                  ),
                )
                    .call(
                  {
                    "word": _controller.value.text,
                  },
                ).then((result) {
                  setState(() {
                    _response = result.data as String;
                  });
                }).catchError((err) {
                  if (err is FirebaseFunctionsException) {
                    debugPrint(err.code);
                    debugPrint(err.details);
                    debugPrint(err.message);
                  } else {
                    debugPrint(err.toString());
                  }
                });
              },
              child: const Text("Callable V2"),
            ),
            Text(
              _response,
            ),
          ],
        ),
      ),
    );
  }
}
