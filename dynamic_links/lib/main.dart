// Copyright 2023 Google LLC
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

import 'package:dynamiclinks_quickstart/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: (context, child) => const MyApp(),
  ));
}

const title = 'Firebase Dynamic Links Quickstart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        //
        // This is the theme of your application.
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ApplicationState>(
          builder: (context, appState, _) => Column(
            children: [
              const Text('Recieved:'),
              Text(appState.receivedLink != null
                  ? appState.receivedLink.toString()
                  : "No link received"),
              const Text('Send:'),
              Text(appState.dynamicLink),
              ElevatedButton(
                onPressed: () => {
                  Share.share(
                    appState.dynamicLink,
                    subject: 'Come see dynamic links in action',
                  )
                },
                child: Text('Share Dynamic Link'),
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

  // Found at https://console.firebase.google.com/project/_/durablelinks/links/
  final uriPrefix = 'https://dynamiclinksquickstart.page.link'; // 🔥
  final url = 'https://flutter.dev/firebase?magical=yes';

  late FirebaseDynamicLinks dynamicLinks;

  Uri? _receivedLink;
  Uri? get receivedLink => _receivedLink;

  String _dynamicLink = '';
  String get dynamicLink => _dynamicLink;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    dynamicLinks = FirebaseDynamicLinks.instance;
    final initialLink = await dynamicLinks.getInitialLink();

    if (initialLink != null) {
      debugPrint('initial Link Received!');
      _receivedLink = initialLink.link;
      notifyListeners();
    }

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      print('received dynamic link');
      _receivedLink = dynamicLinkData.link;
      notifyListeners();
    }).onError((error) {
      // Handle errors
      print('error with link ${error.toString()}');
    });

    createDynamicLink().then((value) {
      _dynamicLink = value;
      notifyListeners();
    });
  }

  Future<String> createDynamicLink() async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(url),
      uriPrefix: uriPrefix,
      androidParameters: const AndroidParameters(
        packageName: 'com.google.firebase.quickstart.dynamiclinks_quickstart',
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.google.firebase.quickstart.dynamiclinksQuickstart',
        appStoreId: '', // 🔥 Add in your own AppStoreID here.
        fallbackUrl: Uri.parse(url),
      ),
      navigationInfoParameters: const NavigationInfoParameters(
        forcedRedirectEnabled: true,
      ),
    );
    final shortLink = await dynamicLinks.buildShortLink(
      dynamicLinkParams,
      shortLinkType: ShortDynamicLinkType.unguessable,
    );
    debugPrint(shortLink.shortUrl.toString());
    return shortLink.shortUrl.toString();
  }
}
