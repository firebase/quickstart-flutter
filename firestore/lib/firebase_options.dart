import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// Run 'flutterfire configure' to generate platform-specific FirebaseOptions.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    throw StateError(
        "firebase_options.dart not generated. Did you run 'flutterfire configure'?");
  }
}
