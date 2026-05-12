class UpdateTestReviewParams {
  final int testId;
  final int rating;
  final String reviewText;

  const UpdateTestReviewParams({
    required this.testId,
    required this.rating,
    required this.reviewText,
  });
}