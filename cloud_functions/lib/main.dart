import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(state: ApplicationState()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.state});

  final ApplicationState state;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Firebase Functions Quickstart', state: state),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title, required this.state});

  final String title;
  final ApplicationState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Card(
            elevation: 4.0,
            margin: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('Add Two Numbers'),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 64.0,
                        child: ListenableBuilder(
                          listenable: state,
                          builder: (context, child) => TextField(
                            onChanged: (value) => state.mathInputOne = value,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Text('+'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 64.0,
                        child: ListenableBuilder(
                          listenable: state,
                          builder: (context, child) => TextField(
                            onChanged: (value) => state.mathInputTwo = value,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Text('='),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 64.0,
                        child: ListenableBuilder(
                          listenable: state,
                          builder: (context, child) => Text(state.mathOutput),
                        ),
                      ),
                    ),
                  ],
                ),
                ListenableBuilder(
                  listenable: state,
                  builder: (context, child) {
                    return ElevatedButton(
                      onPressed: () {
                        state.callAddNumbers();
                      },
                      child: const Text('Calculate'),
                    );
                  },
                ),
              ],
            ),
          ),
          Card(
            elevation: 4.0,
            margin: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('Sanitize a Message'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: ListenableBuilder(
                      listenable: state,
                      builder: (context, child) => TextField(
                        onChanged: (value) => state.sanatizeInput = value,
                        decoration: const InputDecoration(
                          labelText: 'Input',
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: ListenableBuilder(
                      listenable: state,
                      builder: (context, child) => Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Output: ${state.sanatizeOutput}',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ListenableBuilder(
                        listenable: state,
                        builder: (context, child) => Row(
                          children: [
                            ElevatedButton(
                              onPressed:
                                  state.signedIn ? null : () => state.signIn(),
                              child: const Text('Sign In'),
                            ),
                            ElevatedButton(
                              onPressed: () => state.callAddMessage(),
                              child: const Text('Sanitize'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  String mathInputOne = '';
  String mathInputTwo = '';
  String mathOutput = '';

  String sanatizeInput = '';
  String sanatizeOutput = '';

  bool _signedIn = false;
  bool get signedIn => _signedIn;

  late FirebaseFunctions functions;
  late HttpsCallable addNumbers;
  late HttpsCallable addMessage;
  late FirebaseAuth auth;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Uncomment out the following to run against an emulator
    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFunctions.instance.useFunctionsEmulator("localhost", 5001);

    functions = FirebaseFunctions.instance;
    auth = FirebaseAuth.instance;
    addNumbers = functions.httpsCallable('addNumbers');
    addMessage = functions.httpsCallable('addMessage');

    auth.authStateChanges().listen((event) {
      _signedIn = auth.currentUser != null;
      notifyListeners();
    });
  }

  void callAddNumbers() {
    addNumbers.call(
      {
        'firstNumber': double.parse(mathInputOne),
        'secondNumber': double.parse(mathInputTwo),
      },
    ).then((value) => {
          mathOutput = value.data['operationResult'].toString(),
          notifyListeners(),
        });
  }

  void callAddMessage() {
    addMessage.call(
      {
        'text': sanatizeInput,
      },
    ).then((value) => {
          debugPrint(value.data.toString()),
          sanatizeOutput = value.data.toString(),
          notifyListeners(),
        });
  }

  void signIn() {
    auth.signInAnonymously();
  }
}
