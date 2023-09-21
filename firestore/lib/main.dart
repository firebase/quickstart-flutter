import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'firebase_options.dart';
import 'src/app.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   if (kDebugMode) {
   try {
     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
     await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
   } catch (e) {
     // ignore: avoid_print
     print(e);
   }
 }

  // required to interact with Firestore due to security Rules
  await FirebaseAuth.instance.signInAnonymously();

  runApp(FriendlyEatsApp());
}
