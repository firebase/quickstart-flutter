import 'package:flutter/material.dart';

import 'app_state.dart';
import 'user_constants.dart';

Widget seasonSelector(ApplicationState appState) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: SegmentedButton<Season>(
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
  );
}

Widget preferredTempSelector(ApplicationState appState) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Row(
      children: [
        const Expanded(
          child: Text(
            'Preferred Temperature Units:',
          ),
        ),
        const Spacer(),
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
          selected: <PreferredTempUnits>{appState.selectedTempUnts.first},
          emptySelectionAllowed: true,
          onSelectionChanged: (Set<PreferredTempUnits> tempUnits) {
            appState.selectTempUnits(tempUnits);
          },
        ),
      ],
    ),
  );
}

Widget hotOrColdSelector(ApplicationState appState) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Row(
      children: [
        const Expanded(
          child: Text('Hot or cold weather?'),
        ),
        const Spacer(),
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
          selected: <PreferredWeatherTemp>{appState.selectedWeatherTemp.first},
          emptySelectionAllowed: true,
          onSelectionChanged: (Set<PreferredWeatherTemp> weatherTemp) {
            appState.selectWeatherTemp(weatherTemp);
          },
        ),
      ],
    ),
  );
}

Widget rainOrSunshineSelector(ApplicationState appState) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Row(
      children: [
        const Expanded(
          child: Text('Rainy or sunny days?'),
        ),
        const Spacer(),
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
          selected: <PreferredWeatherCond>{appState.weatherCond.first},
          emptySelectionAllowed: true,
          onSelectionChanged: (Set<PreferredWeatherCond> weatherCond) {
            appState.selectWeatherCond(weatherCond);
          },
        ),
      ],
    ),
  );
}

Widget preferredTemperatureSelector(ApplicationState appState) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Column(
      children: [
        Text(
          'Preferred temperature: ${appState.preferredTemp.round()}',
        ),
        Slider(
          value: appState.preferredTemp,
          max: 100,
          min: 0,
          onChanged: (double newTemp) {
            appState.setPreferredTemp(newTemp);
          },
        )
      ],
    ),
  );
}
