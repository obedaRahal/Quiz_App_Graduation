class ReviewFeedbackActionParams {
  final int reviewId;
  final String vote;

  const ReviewFeedbackActionParams({
    required this.reviewId,
    required this.vote,
  });
}