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

import 'package:flutter/material.dart';

import '../model/restaurant.dart';
import 'restaurant_card.dart';

class RestaurantGrid extends StatelessWidget {
  const RestaurantGrid({
    super.key,
    required RestaurantPressedCallback onRestaurantPressed,
    required List<Restaurant> restaurants,
  })  : _onRestaurantPressed = onRestaurantPressed,
        _restaurants = restaurants;

  final RestaurantPressedCallback _onRestaurantPressed;
  final List<Restaurant> _restaurants;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 5.0,
      children: _restaurants
          .map((restaurant) => RestaurantCard(
                restaurant: restaurant,
                onRestaurantPressed: _onRestaurantPressed,
              ))
          .toList(),
    );
  }
}
