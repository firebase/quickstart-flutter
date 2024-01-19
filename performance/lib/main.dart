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

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:performance_quickstart/firebase_status.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import './firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp(state: ApplicationState()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.state});
  
  final ApplicationState state;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Performance Monitoring',
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
      home: MyHomePage(title: 'Firebase Performance Monitoring', state: state),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title, required this.state});

  final String title;
  final ApplicationState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: ListenableBuilder
          (
          listenable: state,
          builder: (context, child) => Column(
            children: <Widget>[
              const Image(
                  image:
                      AssetImage('assets/perfmon_horizonal_lockup_light.png')),
              const Text('We are using Performance monitoring to monitor a '
                  'function that gets a random string.'),
              ElevatedButton(
                onPressed: () => {state.updateRandomString()},
                child: const Text('Get Random String'),
              ),
              Text(state.randomString),
              ElevatedButton(
                onPressed: () => {state.getFirebaseStatus()},
                child: const Text('Get Firebase Status'),
              ),
              InkWell(
                child: Text(state.lastIncident),
                onTap: () => state
                    ._launchInWebViewOrVC(Uri.parse(state.lastIncidentUri)),
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

  String _randomString = '';
  String get randomString => _randomString;

  final _firebaseStatusURL =
      'https://status.firebase.google.com/incidents.json';
  final _firebaseStatusBaseUri = 'https://status.firebase.google.com';

  String _lastIncident = '';
  String get lastIncident => _lastIncident;

  String _lastIncidentUri = '';
  String get lastIncidentUri => _lastIncidentUri;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
    HttpClient.enableTimelineLogging = true;
  }

  Future<void> updateRandomString() async {
    var trace = FirebasePerformance.instance.newTrace('updateRandomString');
    await trace.start();
    var buffer = StringBuffer();
    const options = 'abcdfghijklmnopqrstuvwxyz0123456789';
    var random = Random();
    var randomSize = random.nextInt(100) + 1;
    for (var i = 0; i < randomSize; i++) {
      var nextNum = random.nextInt(options.length);
      buffer.write(options[nextNum]);
    }
    _randomString = buffer.toString();
    notifyListeners();
    await trace.stop();
  }

  Future<void> getFirebaseStatus() async {
    final metric = FirebasePerformance.instance
        .newHttpMetric(_firebaseStatusBaseUri, HttpMethod.Get);

    await metric.start();
    final response = await http.get(Uri.parse(_firebaseStatusURL));
    await metric.stop();

    var responseString = response.body;
    var jsonResponseString = '{ "response": $responseString }';

    var responses = ResponseJson.fromJson(jsonDecode(jsonResponseString));

    // Responses come in sorted, so getting the first element in the list is
    // sufficient
    if (responses.response != null) {
      var status =
          '${responses.response![0].externalDesc} \nLast updated: ${responses.response![0].modified}';
      _lastIncident = status;
      _lastIncidentUri =
          '$_firebaseStatusBaseUri/${responses.response![0].uri}';
      notifyListeners();
    }
  }

  Future<void> _launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
    )) {
      throw 'Could not launch $url';
    }
  }
}
