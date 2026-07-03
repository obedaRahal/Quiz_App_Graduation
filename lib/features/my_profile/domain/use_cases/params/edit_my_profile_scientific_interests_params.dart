class EditMyProfileScientificInterestsParams {
  final int userId;
  final List<int> interestIds;

  const EditMyProfileScientificInterestsParams({
    required this.userId,
    required this.interestIds,
  });

  Map<String, dynamic> toBody() {
    return {
      'interest_ids': interestIds,
    };
  }
}