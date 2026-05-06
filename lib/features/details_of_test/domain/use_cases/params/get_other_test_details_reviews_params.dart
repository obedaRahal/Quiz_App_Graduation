class GetOtherTestDetailsReviewsParams {
  final int testId;
  final String rating;

  const GetOtherTestDetailsReviewsParams({
    required this.testId,
    this.rating = 'all',
  });
}