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

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'data/restaurant_provider.dart';
import 'model/restaurant.dart';
import 'model/review.dart';
import 'widgets/dialogs/review_create.dart';
import 'widgets/restaurant_page_details.dart';
import 'widgets/review_list_tile.dart';

class RestaurantPage extends StatefulWidget {
  static const route = '/restaurant';

  final String restaurantId;

  RestaurantPage({Key? key, required String restaurantId})
      : restaurantId = restaurantId,
        super(key: key);

  @override
  _RestaurantPageState createState() => _RestaurantPageState(restaurantId);
}

class _RestaurantPageState extends State<RestaurantPage> {
  _RestaurantPageState(String restaurantId) {
    _initAsyncData(restaurantId);
  }

  void _initAsyncData(String restaurantId) async {
    final credential = await FirebaseAuth.instance.signInAnonymously();

    final restaurant =
        await _firestoreRestaurantProvider.getRestaurantById(restaurantId);
    final reviews = await _firestoreRestaurantProvider
        .getReviewsForRestaurant(restaurantId);

    setState(() {
      _user = credential.user!;
      _restaurant = restaurant;
      _reviews = reviews;
      _isLoading = false;
    });
  }

  late final Restaurant _restaurant;
  late final User _user;
  late List<Review> _reviews;
  bool _isLoading = true;
  final FirestoreRestaurantProvider _firestoreRestaurantProvider =
      FirestoreRestaurantProvider();

  void _onCreateReviewPressed(BuildContext context) async {
    final newReview = await showDialog<Review>(
      context: context,
      builder: (BuildContext context) => ReviewCreateDialog(
        userId: _user.uid,
        userName: _user.displayName ?? 'Anonymous User',
      ),
    );
    if (newReview != null) {
      // Save the review
      await _firestoreRestaurantProvider.addReview(
        restaurantId: _restaurant.id!,
        review: newReview,
      );
    }

    _updateReviews();
  }

  void _onAddRandomReviewsPressed() async {
    // Await adding a random number of random reviews
    final numReviews = Random().nextInt(5) + 5;
    for (var i = 0; i < numReviews; i++) {
      await _firestoreRestaurantProvider.addReview(
        restaurantId: _restaurant.id!,
        review: Review.random(
          userId: _user.uid,
          userName: _user.displayName ?? 'Anonymous User',
        ),
      );
    }

    _updateReviews();
  }

  void _updateReviews() async {
    final reviews = await _firestoreRestaurantProvider
        .getReviewsForRestaurant(_restaurant.id!);
    setState(() {
      _reviews = reviews;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
              child: Icon(Icons.add),
              tooltip: 'Tap to add a review',
              onPressed: () => _onCreateReviewPressed(context),
            ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Builder(
              builder: (BuildContext context) {
                return Center(
                  child: Container(
                    color: Colors.white,
                    constraints: BoxConstraints(maxWidth: 900),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        RestaurantDetails(restaurant: _restaurant),
                        Divider(thickness: 1),
                        _reviews.isNotEmpty
                            ? Flexible(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: _reviews.length,
                                  separatorBuilder: (context, index) =>
                                      Divider(thickness: 1),
                                  itemBuilder: (context, index) {
                                    return ReviewListTile(
                                      review: _reviews[index],
                                    );
                                  },
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 24.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                        'There are no reviews yet! Generate random reviews with button.'),
                                    ElevatedButton(
                                        onPressed: _onAddRandomReviewsPressed,
                                        child: Text('Add Random Reviews'))
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class RestaurantPageArguments {
  final String restaurantId;

  RestaurantPageArguments(this.restaurantId);
}
