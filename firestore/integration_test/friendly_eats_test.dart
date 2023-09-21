import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore/firebase_options.dart';
import 'package:firestore/src/app.dart';
import 'package:firestore/src/widgets/restaurant_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

bool USE_FIRESTORE_EMULATOR = true;

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  final hostUrl = defaultTargetPlatform == TargetPlatform.android ? "10.0.2.2" : "localhost";
  if (USE_FIRESTORE_EMULATOR) {
    FirebaseFirestore.instance.useFirestoreEmulator(hostUrl, 8080);
    await FirebaseAuth.instance.useAuthEmulator(hostUrl, 9099);
    await FirebaseAuth.instance.signInAnonymously();
  }
    group('Integration Tests', () {
      testWidgets('Test empty home page', (tester) async {
        await tester.pumpWidget(FriendlyEatsApp());
        expect(find.text('FriendlyEats has no restaurants yet!'), findsOneWidget);
        expect(find.text('ADD SOME'), findsOneWidget);
        await tester.tap(find.text('ADD SOME').first);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        expect(find.byIcon(Icons.star), findsWidgets);
      });
      testWidgets('view restaurant page', (tester) async {
        await tester.pumpWidget(FriendlyEatsApp());
        await tester.tap(find.byType(RestaurantCard));
        await tester.pumpAndSettle(const Duration(seconds: 1));
        expect(find.text('Add Random Reviews'), findsOneWidget);
        await tester.tap(find.text('Add Random Reviews'));
        await tester.pumpAndSettle(const Duration(seconds: 1));
        expect(find.text('Anonymous User'), findsWidgets);
      });
  });
}