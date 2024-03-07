import 'package:flutter/material.dart';
import 'package:storage/src/page/home.dart';
import 'package:storage/src/page/library.dart';

class App extends StatelessWidget {
  const App({super.key});
  // const App({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/library': (context) => const LibraryPage()
      },
    );
  }
}
