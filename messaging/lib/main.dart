// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Firebase In App Messaging'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Image(
                image: AssetImage('assets/fcm_horizontal_lockup_light.png')),
            const Text(
              'Click the SUBSCRIBE TO WEATHER button below to subscribe to the'
              ' weather topic. Messages sent to the weather topic will be'
              ' received.',
            ),
            Consumer<ApplicationState>(
              builder: (context, appState, _) =>
                  Text('FCM Token: ${appState.fcmToken}'),
            ),
            Consumer<ApplicationState>(
              builder: (context, appState, _) => ElevatedButton(
                onPressed: () => appState.subscribeToTopic('weather'),
                child: const Text('Subscribe To Weather'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  late FirebaseMessaging firebaseMessaging;

  String _fcmToken = '';
  String get fcmToken => _fcmToken;

  bool _messagingAllowed = false;
  bool get messagingAllowed => _messagingAllowed;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    firebaseMessaging = FirebaseMessaging.instance;

    firebaseMessaging.onTokenRefresh.listen((token) {
      _fcmToken = token;
      notifyListeners();
      // If necessary send token to application server.

      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    });

    firebaseMessaging.getNotificationSettings().then((settings) {
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        _messagingAllowed = true;
        notifyListeners();
      }
    });
  }

  Future<void> requestMessagingPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _messagingAllowed = true;
      notifyListeners();
    }

    debugPrint('Users permission status: ${settings.authorizationStatus}');
  }

  Future<void> subscribeToTopic(String topic) async {
    await firebaseMessaging.subscribeToTopic(topic);
  }
}
