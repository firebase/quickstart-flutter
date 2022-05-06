import 'dart:async';

import 'package:crashlytics/app.dart';
import 'package:crashlytics/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

void main() async {
  /// Not all errors are caught by Flutter.
  /// Sometimes, errors are instead caught by Zones.
  /// A common case where relying on Flutter to catch errors would not be
  /// enough is when an exception happens inside the onPressed handler of
  /// a button. To catch such errors, you can use runZonedGuarded.
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Used to measure "Crash Free Users" on the Crashlytics dashboard.
    // Any analytics event can be used.
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics.logEvent(name: "App Opened");

    // Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    runApp(const MyApp());
  }, (Object error, StackTrace stackTrace) {
    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      fatal: true,
    );
  });
}
