import 'package:authentication/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Both of the following lines are good for testing,
  // but can be removed for release builds
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseAuth.instance.signOut();

  runApp(const AuthApp());
}
