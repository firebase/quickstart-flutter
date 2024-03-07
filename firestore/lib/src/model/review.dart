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

// This is called "ratings" in the backend.
class Review {
  late final String id;
  final String userId;
  final double rating;
  final String text;
  final String userName;
  late final Timestamp timestamp;
  late final DocumentReference reference;

  Review._({
    required this.id,
    required this.userId,
    required this.rating,
    required this.text,
    required this.userName,
    required this.timestamp,
    required this.reference,
  });

  factory Review.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Review._(
      id: snapshot.id,
      userId: data['userId'],
      rating: data['rating'].toDouble(),
      text: data['text'],
      userName: data['userName'],
      timestamp: data['timestamp'],
      reference: snapshot.reference,
    );
  }

  Review.fromUserInput({
    required this.rating,
    required this.text,
    required this.userName,
    required this.userId,
  }) : timestamp = Timestamp.now();

  factory Review.random({
    required String userName,
    required String userId,
  }) {
    final rating = Random().nextInt(4) + 1;
    final review = getRandomReviewText(rating);
    return Review.fromUserInput(
      rating: rating.toDouble(),
      text: review,
      userName: userName,
      userId: userId,
    );
  }

  bool get isPositive => rating >= 3.0;
}
