/*
 *  Copyright 2022 Google LLC
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

import 'package:flutter/material.dart';

import '../model/restaurant.dart';
import '../widgets/star_rating.dart';

class RestaurantDetails extends StatelessWidget {
  const RestaurantDetails({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: 'restaurant-image-${restaurant.id}',
          child: SizedBox(
            height: 200.0,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.center,
                  image: NetworkImage(restaurant.photo!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            left: 16.0,
            right: 16.0,
          ),
          child: Text(
            restaurant.name,
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 16.0,
          ),
          child: Row(
            children: [
              StaticStarRating(
                rating: restaurant.avgRating,
                color: Colors.blue,
                size: 24,
              ),
              Text('  ${restaurant.avgRating} ( ${restaurant.numRatings} )'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 24.0,
            left: 16.0,
          ),
          child: Row(
            children: [
              if (restaurant.price != null)
                Text(
                  '\$' * restaurant.price!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              Text(
                ' ● ${restaurant.category} ● ${restaurant.city}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        )
      ],
    );
  }
}
