import 'package:flutter/material.dart';

import '../model/review.dart';
import 'review_list_tile.dart';

class RestaurantPageReviewList extends StatelessWidget {
  const RestaurantPageReviewList({
    super.key,
    required this.reviews,
  });

  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: reviews.length,
        separatorBuilder: (context, index) => const Divider(thickness: 1),
        itemBuilder: (context, index) {
          return ReviewListTile(
            review: reviews[index],
          );
        },
      ),
    );
  }
}
