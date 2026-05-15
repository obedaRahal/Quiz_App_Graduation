class GetOtherTestDetailsReviewsParams {
  final int testId;
  final String rating;
  final int page;

  const GetOtherTestDetailsReviewsParams({
    required this.testId,
    this.rating = 'all',
    this.page = 1,
  });
}
