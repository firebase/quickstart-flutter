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

// Background message handler :
// https://firebase.google.com/docs/cloud-messaging/flutter/receive#background_messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
      home: const MyHomePage(title: 'Firebase Cloud Messaging'),
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
        child: Consumer<ApplicationState>(
          builder: (context, appState, _) => Column(
            children: <Widget>[
              const Image(
                  image: AssetImage('assets/fcm_horizontal_lockup_light.png')),
              Visibility(
                visible: appState.messagingAllowed,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Click the "Subscribe To Weather" button below to subscribe to the'
                        ' "weather" topic. Messages sent to the weather topic will be'
                        ' received.',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('FCM Token: ${appState.fcmToken}'),
                    ),
                    ElevatedButton(
                      onPressed: () => appState.subscribeToTopic('weather'),
                      child: const Text('Subscribe To Weather'),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: !appState.messagingAllowed,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Thi quickstart requires notification permissions to be'
                        ' activated.',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => appState.requestMessagingPermission(),
                      child: const Text('Request Notification Permission'),
                    ),
                  ],
                ),
              )
            ],
          ),
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
      debugPrint(token);
      notifyListeners();
      // If necessary send token to application server.

      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    });

    // Replace this with your key for web apps.
    const vapidKey = '';
    firebaseMessaging.getToken(vapidKey: vapidKey).then((token) {
      if (token != null) {
        _fcmToken = token;
        debugPrint(token);
        notifyListeners();
      }
    });

    firebaseMessaging.getNotificationSettings().then((settings) {
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        _messagingAllowed = true;
        notifyListeners();
      }
    });

    FirebaseMessaging.onMessage.listen((remoteMessage) {
      debugPrint('Got a message in the foreground');
      debugPrint('message data: ${remoteMessage.data}');

      if (remoteMessage.notification != null) {
        debugPrint('message is a notification');
        // On Android, foreground notifications are not shown, only when the app
        // is backgrounded.
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
