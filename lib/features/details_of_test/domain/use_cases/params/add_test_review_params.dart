class AddTestReviewParams {
  final int testId;
  final int rating;
  final String reviewText;

  const AddTestReviewParams({
    required this.testId,
    required this.rating,
    required this.reviewText,
  });
}