import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;

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
      title: 'Flutter Demo',
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
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            Title(
              color: Colors.orange,
              child: const Text(
                'Firebase Analytics',
              ),
            ),
            const Text(
              'Interact with the various controls to start collecting analytics data.',
            ),
            const Text(
              'Set user properties',
            ),
            Consumer<ApplicationState>(
              builder: (context, appState, _) => SegmentedButton<Season>(
                segments: const <ButtonSegment<Season>>[
                  ButtonSegment<Season>(
                    value: Season.spring,
                    label: Text('Spring'),
                  ),
                  ButtonSegment<Season>(
                    value: Season.summer,
                    label: Text('Summer'),
                  ),
                  ButtonSegment<Season>(
                    value: Season.autumn,
                    label: Text('Autumn'),
                  ),
                  ButtonSegment<Season>(
                    value: Season.winter,
                    label: Text('Winter'),
                  ),
                ],
                selected: <Season>{appState.selectedSeason.first},
                emptySelectionAllowed: true,
                onSelectionChanged: (Set<Season> newSeason) {
                  appState.selectSeason(newSeason);
                },
              ),
            ),
            Row(
              children: [
                Text('Preferred Temperature Units:'),
                Consumer<ApplicationState>(
                  builder: (context, appState, _) =>
                      SegmentedButton<PreferredTempUnits>(
                    segments: const <ButtonSegment<PreferredTempUnits>>[
                      ButtonSegment<PreferredTempUnits>(
                        value: PreferredTempUnits.c,
                        label: Text('\u00b0C'),
                      ),
                      ButtonSegment<PreferredTempUnits>(
                        value: PreferredTempUnits.f,
                        label: Text('\u00b0F'),
                      ),
                    ],
                    selected: <PreferredTempUnits>{
                      appState.selectedTempUnts.first
                    },
                    emptySelectionAllowed: true,
                    onSelectionChanged: (Set<PreferredTempUnits> tempUnits) {
                      appState.selectTempUnits(tempUnits);
                    },
                  ),
                ),
              ],
            ),
            const Text('Log user interactions with events'),
            Row(
              children: [
                Text('Hot or cold weather?'),
                Consumer<ApplicationState>(
                  builder: (context, appState, _) =>
                      SegmentedButton<PreferredWeatherTemp>(
                    segments: const <ButtonSegment<PreferredWeatherTemp>>[
                      ButtonSegment<PreferredWeatherTemp>(
                        value: PreferredWeatherTemp.hot,
                        label: Text('Hot'),
                      ),
                      ButtonSegment<PreferredWeatherTemp>(
                        value: PreferredWeatherTemp.cold,
                        label: Text('Cold'),
                      ),
                    ],
                    selected: <PreferredWeatherTemp>{
                      appState.selectedWeatherTemp.first
                    },
                    emptySelectionAllowed: true,
                    onSelectionChanged:
                        (Set<PreferredWeatherTemp> weatherTemp) {
                      appState.selectWeatherTemp(weatherTemp);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('Rainy or sunny days?'),
                Consumer<ApplicationState>(
                  builder: (context, appState, _) =>
                      SegmentedButton<PreferredWeatherCond>(
                    segments: const <ButtonSegment<PreferredWeatherCond>>[
                      ButtonSegment<PreferredWeatherCond>(
                        value: PreferredWeatherCond.rain,
                        label: Text('Rainy'),
                      ),
                      ButtonSegment<PreferredWeatherCond>(
                        value: PreferredWeatherCond.sun,
                        label: Text('Sunny'),
                      ),
                    ],
                    selected: <PreferredWeatherCond>{
                      appState.weatherCond.first
                    },
                    emptySelectionAllowed: true,
                    onSelectionChanged:
                        (Set<PreferredWeatherCond> weatherCond) {
                      appState.selectWeatherCond(weatherCond);
                    },
                  ),
                ),
              ],
            ),
            Consumer<ApplicationState>(
                builder: (context, appState, _) => Column(
                      children: [
                        Text(
                          'Preferred temperature: ${appState.preferredTemp.round()}',
                        ),
                        Slider(
                          value: appState.preferredTemp,
                          divisions: 100,
                          max: 100,
                          min: 0,
                          onChanged: (double newTemp) {
                            appState.setPreferredTemp(newTemp);
                          },
                        )
                      ],
                    )),
          ],
        ),
      ),
    );
  }
}

enum Season { spring, summer, autumn, winter, none }

enum PreferredTempUnits { c, f, none }

enum PreferredWeatherTemp { hot, cold, none }

enum PreferredWeatherCond { rain, sun, none }

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Set<Season> _selectedSeason = <Season>{Season.none};
  Set<Season> get selectedSeason => _selectedSeason;

  Set<PreferredWeatherTemp> _selectedWeatherTemp = <PreferredWeatherTemp>{
    PreferredWeatherTemp.none
  };
  Set<PreferredWeatherTemp> get selectedWeatherTemp => _selectedWeatherTemp;

  Set<PreferredTempUnits> _selectedTempUnts = <PreferredTempUnits>{
    PreferredTempUnits.none
  };
  Set<PreferredTempUnits> get selectedTempUnts => _selectedTempUnts;

  Set<PreferredWeatherCond> _weatherCond = <PreferredWeatherCond>{
    PreferredWeatherCond.none
  };
  Set<PreferredWeatherCond> get weatherCond => _weatherCond;

  double _preferredTemp = 0;
  double get preferredTemp => _preferredTemp;

  Future<void> init() async {}

  void selectSeason(Set<Season> season) {
    if (season.isEmpty) {
      return;
    }
    _selectedSeason = <Season>{season.first};
    notifyListeners();
  }

  void selectTempUnits(Set<PreferredTempUnits> tempUnits) {
    if (tempUnits.isEmpty) {
      return;
    }
    _selectedTempUnts = <PreferredTempUnits>{tempUnits.first};
    notifyListeners();
  }

  void selectWeatherTemp(Set<PreferredWeatherTemp> weatherTemp) {
    if (weatherTemp.isEmpty) {
      return;
    }
    _selectedWeatherTemp = <PreferredWeatherTemp>{weatherTemp.first};
    notifyListeners();
  }

  void selectWeatherCond(Set<PreferredWeatherCond> weatherCond) {
    if (weatherCond.isEmpty) {
      return;
    }

    _weatherCond = <PreferredWeatherCond>{weatherCond.first};
    notifyListeners();
  }

  void setPreferredTemp(double newTemp) {
    _preferredTemp = newTemp;
    notifyListeners();
  }
}
