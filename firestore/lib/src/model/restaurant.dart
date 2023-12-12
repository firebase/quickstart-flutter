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

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import './values.dart';

typedef RestaurantPressedCallback = void Function(Restaurant restaurant);

typedef CloseRestaurantPressedCallback = void Function();

class Restaurant {
  final String? id;
  final String name;
  final String? category;
  final String? city;
  final double avgRating;
  final int numRatings;
  final int? price;
  final String? photo;
  final DocumentReference? reference;

  Restaurant._({
    required this.name,
    this.category,
    this.city,
    this.price,
    this.photo,
    this.id,
    this.numRatings = 0,
    this.avgRating = 0,
    this.reference,
  });

  factory Restaurant.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Restaurant._(
      id: snapshot.id,
      name: data['name'],
      category: data['category'],
      city: data['city'],
      avgRating: data['avgRating'].toDouble(),
      numRatings: data['numRatings'],
      price: data['price'],
      photo: data['photo'],
      reference: snapshot.reference,
    );
  }

  factory Restaurant.random() {
    return Restaurant._(
      category: getRandomCategory(),
      city: getRandomCity(),
      name: getRandomName(),
      price: Random().nextInt(3) + 1,
      photo: getRandomPhoto(),
    );
  }
}
