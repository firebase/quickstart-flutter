import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../common/authentication_providers.dart';
import '../firebase_options.dart';

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

      case AuthenticationProviders.anonymous:
        {
          await FirebaseAuth.instance.signInAnonymously();
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
