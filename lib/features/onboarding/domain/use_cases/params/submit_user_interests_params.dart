class SubmitUserInterestsParams {
  final String email;
  final List<int> interestIds;

  const SubmitUserInterestsParams({
    required this.email,
    required this.interestIds,
  });
}