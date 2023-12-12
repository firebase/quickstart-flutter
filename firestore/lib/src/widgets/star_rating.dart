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

typedef RatingChangeCallback = void Function(double rating);

class SmoothStarRating extends StatelessWidget {
  final int? starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color? color;
  final Color? borderColor;
  final double? size;
  final bool allowHalfRating;
  final IconData? filledIconData;
  final IconData? halfFilledIconData;
  final IconData?
      defaultIconData; //this is needed only when having fullRatedIconData && halfRatedIconData
  final double spacing;
  const SmoothStarRating({
    super.key,
    this.starCount = 5,
    this.spacing = 0.0,
    this.rating = 0.0,
    this.defaultIconData,
    required this.onRatingChanged,
    this.color,
    this.borderColor,
    this.size = 24,
    this.filledIconData,
    this.halfFilledIconData,
    this.allowHalfRating = true,
  });

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        defaultIconData ?? Icons.star_border,
        color: borderColor ?? Theme.of(context).primaryColor,
        size: size,
      );
    } else if (index > rating - (allowHalfRating ? 0.5 : 1.0) &&
        index < rating) {
      icon = Icon(
        halfFilledIconData ?? Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      );
    } else {
      icon = Icon(
        filledIconData ?? Icons.star,
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      );
    }

    return GestureDetector(
      onTap: () => onRatingChanged(index + 1.0),
      onHorizontalDragUpdate: (dragDetails) {
        RenderBox? box = context.findRenderObject() as RenderBox?;
        var pos = box!.globalToLocal(dragDetails.globalPosition);
        var i = pos.dx / size!;
        var newRating = allowHalfRating ? i : i.round().toDouble();
        if (newRating > starCount!) {
          newRating = starCount!.toDouble();
        }
        if (newRating < 0) {
          newRating = 0.0;
        }
        onRatingChanged(newRating);
      },
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: spacing,
        children: List.generate(
          starCount!,
          (index) => buildStar(context, index),
        ),
      ),
    );
  }
}

class StaticStarRating extends StatelessWidget {
  const StaticStarRating({
    super.key,
    this.color,
    this.size,
    required this.rating,
  });

  final Color? color;
  final double? size;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return SmoothStarRating(
      onRatingChanged: (double rating) {},
      color: color,
      size: size,
      rating: rating,
    );
  }
}
