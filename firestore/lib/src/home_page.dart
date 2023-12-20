// Copyright 2020 Google LLC
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

import 'dart:async';

import 'package:flutter/material.dart';

import 'data/restaurant_provider.dart';
import 'model/filter.dart';
import 'model/restaurant.dart';
import 'restaurant_page.dart';
import 'utils.dart' as utils;
import 'widgets/dialogs/filter_select.dart';
import 'widgets/empty_listview.dart';
import 'widgets/filter_bar.dart';
import 'widgets/restaurant_grid.dart';

class HomePage extends StatefulWidget {
  static const route = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  final FirestoreRestaurantProvider _firestoreRestaurantProvider =
      FirestoreRestaurantProvider();
  Filter _filter = Filter();

  @override
  void initState() {
    _firestoreRestaurantProvider.loadAllRestaurants();
    _isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    _firestoreRestaurantProvider.dispose();
    super.dispose();
  }

  Future<void> _onAddRandomRestaurantsPressed() async {
    _firestoreRestaurantProvider
        .addRestaurantsBatch(utils.createRandomRestaurants());
  }

  Future<void> _onFilterBarPressed() async {
    final filter = await showDialog<Filter>(
      context: context,
      builder: (_) => FilterSelectDialog(filter: _filter),
    );
    if (filter != null) {
      setState(() => _isLoading = true);
      _filter = filter;
      if (filter.isDefault) {
        _firestoreRestaurantProvider.loadAllRestaurants();
      } else {
        _firestoreRestaurantProvider.loadFilteredRestaurants(_filter);
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Restaurant>>(
      stream: _firestoreRestaurantProvider.allRestaurants,
      initialData: const [],
      builder:
          (BuildContext context, AsyncSnapshot<List<Restaurant>> snapshot) {
        final restaurants = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            leading: const Icon(Icons.restaurant),
            title: const Text('FriendlyEats'),
            bottom: PreferredSize(
              preferredSize: const Size(320, 48),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 4),
                child: FilterBar(
                  filter: _filter,
                  onPressed: _onFilterBarPressed,
                ),
              ),
            ),
          ),
          body: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : restaurants.isNotEmpty
                      ? RestaurantGrid(
                          restaurants: restaurants,
                          onRestaurantPressed: (restaurant) {
                            Navigator.pushNamed(
                              context,
                              RestaurantPage.route,
                              arguments: RestaurantPageArguments(restaurant),
                            );
                          },
                        )
                      : EmptyListView(
                          onPressed: _onAddRandomRestaurantsPressed,
                          child: const Text(
                              'FriendlyEats has no restaurants yet!'),
                        ),
            ),
          ),
        );
      },
    );
  }
}
