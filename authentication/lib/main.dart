import 'package:authentication_quickstart/widgets/user_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';
import 'package:authentication_quickstart/common/authentication_providers.dart';
import 'package:authentication_quickstart/widgets/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
      title: 'Authentication Quickstart',
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
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: Consumer<ApplicationState>(
        builder: (context, appState, _) => MyHomePage(appState),
      ),
    );
  }
}

// Should probably be a stateful widget since we need up update selectedIndex
class MyHomePage extends StatelessWidget {
  const MyHomePage(this.appState, {super.key});

  final ApplicationState appState;

  void _onItemTapped(int index) {
    appState.setSelectedScreen(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (appState.selectedScreen == 1)
          ? const SafeArea(child: UserScreen())
          : const SafeArea(
              child: LoginScreen(),
            ),
      // body: const SafeArea(child: LoginScreen()),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.key),
            label: 'Authenticate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: 'User Info',
          ),
        ],
        currentIndex: appState.selectedScreen,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  int _selectedScreen = 0;
  int get selectedScreen => _selectedScreen;

  bool _authenticated = false;
  bool get authenticated => _authenticated;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('no user found');
        _authenticated = false;
        notifyListeners();
        return;
      }
      debugPrint('user found : ${user.uid}');
      _authenticated = true;
      notifyListeners();
    });
  }

  void setSelectedScreen(int selectedScreen) {
    _selectedScreen = selectedScreen;
    notifyListeners();
  }

  Future<void> login(AuthenticationProviders provider,
      {bool linking = false}) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null && linking) {
      debugPrint('cannot link a null user with a new credential');
      return;
    }
    if (user != null && !linking) {
      // FirebaseAuth.instance.signOut(); // Is this necessary?
    }
    switch (provider) {
      case AuthenticationProviders.google:
        {
          if (kIsWeb) {
            var google = GoogleAuthProvider();
            // Uncomment to add an OAuth Scope. More info here :
            // https://developers.google.com/identity/protocols/oauth2/scopes
            // google
            //     .addScope('https://www.googleapis.com/auth/contacts.readonly');
            FirebaseAuth.instance.signInWithProvider(google);
            return;
          }
          // Trigger the authentication flow
          final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

          // Obtain the auth details from the request
          final GoogleSignInAuthentication? googleAuth =
              await googleUser?.authentication;

          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );

          if (linking && user != null) {
            await user.linkWithCredential(credential);
            return;
          }
          await FirebaseAuth.instance.signInWithCredential(credential);
          setSelectedScreen(1);
        }
        break;

      default:
        {
          debugPrint('no provider found');
        }
        break;
    }
  }
}
