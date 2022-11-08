import 'package:authentication_quickstart/state/application_state.dart';
import 'package:authentication_quickstart/widgets/user_screen.dart';

import 'package:authentication_quickstart/widgets/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      title: 'Authentication Quickstart',
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
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: Consumer<ApplicationState>(
        builder: (context, appState, _) => MyHomePage(appState),
      ),
    );
  }
}

// Should probably be a stateful widget since we need up update selectedIndex
class MyHomePage extends StatelessWidget {
  const MyHomePage(this.appState, {super.key});

  final ApplicationState appState;

  void _onItemTapped(int index) {
    appState.setSelectedScreen(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (appState.selectedScreen == 1)
          ? const SafeArea(child: UserScreen())
          : const SafeArea(
              child: LoginScreen(),
            ),
      // body: const SafeArea(child: LoginScreen()),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.key),
            label: 'Authenticate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: 'User Info',
          ),
        ],
        currentIndex: appState.selectedScreen,
        onTap: _onItemTapped,
      ),
    );
  }
}
