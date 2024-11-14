import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static isLoggedIn() async {
    User? user = await FirebaseAuth.instance.authStateChanges().first;
    return user != null;
  }

  static getCurrentUser() {
    return FirebaseAuth.instance.authStateChanges().first;
  }
}
