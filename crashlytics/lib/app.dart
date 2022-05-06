import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crashlytics Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool shouldCrash = false;
  bool shouldCatchNonFatal = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            CrashAppTestWidget(),
            Divider(thickness: 1),
            NonFatalErrorTest(),
          ],
        ),
      ),
    );
  }
}

class CrashAppTestWidget extends StatefulWidget {
  const CrashAppTestWidget({Key? key}) : super(key: key);

  @override
  State<CrashAppTestWidget> createState() => _CrashAppTestWidgetState();
}

class _CrashAppTestWidgetState extends State<CrashAppTestWidget> {
  bool shouldCrash = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text("Should crash on tap?"),
          onChanged: (bool value) {
            setState(() {
              shouldCrash = value;
            });
          },
          value: shouldCrash,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                shouldCrash
                    ? throw Exception('Test exception')
                    : ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fake crash!'),
                        ),
                      );
              },
              child: const Text('CRASH ME!'),
            ),
            const Text(
              'Tap button to throw test Exception',
            ),
          ],
        ),
      ],
    );
  }
}

class NonFatalErrorTest extends StatefulWidget {
  const NonFatalErrorTest({Key? key}) : super(key: key);

  @override
  State<NonFatalErrorTest> createState() => _NonFatalErrorTestState();
}

class _NonFatalErrorTestState extends State<NonFatalErrorTest> {
  void recordNonFatalError() async {
    try {
      // ...
    } catch (e, s) {
      await FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'a non-fatal error');
    }
  }

  bool shouldCatchNonFatal = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text("Should crash on tap?"),
          onChanged: (bool value) {
            setState(() {
              shouldCatchNonFatal = value;
            });
          },
          value: shouldCatchNonFatal,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                shouldCatchNonFatal
                    ? recordNonFatalError()
                    : ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Didn\'t catch'),
                        ),
                      );
              },
              child: const Text('Throw error!'),
            ),
            const Text(
              'Tap button to throw non-fatal error',
            ),
          ],
        ),
      ],
    );
  }
}
