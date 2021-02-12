import 'package:flutter/material.dart';

import '../model/rating.dart';

class RatingAndCommentCount {
  final double ratingMean;
  final int commentCount;

  RatingAndCommentCount._(
      {@required this.ratingMean, @required this.commentCount});

  static RatingAndCommentCount getObject(Iterable<Rating> ratings) {
    double mean = double.nan;
    int length = ratings.length;
    if (length != 0) {
      mean = 0;
      for (Rating rating in ratings) {
        mean += rating.rating;
      }
      mean /= length;
    }
    return RatingAndCommentCount._(
      ratingMean: mean,
      commentCount: length,
    );
  }
}
