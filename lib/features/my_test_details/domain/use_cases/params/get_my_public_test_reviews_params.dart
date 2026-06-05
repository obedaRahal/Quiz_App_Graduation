class GetMyPublicTestReviewsParams {
  final int testId;
  final String rating;
  final int page;

  const GetMyPublicTestReviewsParams({
    required this.testId,
    required this.rating,
    required this.page,
  });
}