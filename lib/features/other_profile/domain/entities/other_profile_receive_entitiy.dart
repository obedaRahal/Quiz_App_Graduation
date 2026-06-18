class OtherProfileReceiveEntity {
  final bool success;
  final String title;
  final OtherProfileReceiveDataEntity data;
  final int statusCode;

  const OtherProfileReceiveEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });
}

class OtherProfileReceiveDataEntity {
  final int userId;
  final bool isThisYourProfile;

  const OtherProfileReceiveDataEntity({
    required this.userId,
    required this.isThisYourProfile,
  });
}