import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_receive_entitiy.dart';

class OtherProfileReceiveModel extends OtherProfileReceiveEntity {
  const OtherProfileReceiveModel({
    required super.success,
    required super.title,
    required OtherProfileReceiveDataModel super.data,
    required super.statusCode,
  });

  factory OtherProfileReceiveModel.fromJson(Map<String, dynamic> json) {
    return OtherProfileReceiveModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      data: OtherProfileReceiveDataModel.fromJson(
        (json['data'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      statusCode: _asInt(json['status_code'], fallback: 200),
    );
  }
}

class OtherProfileReceiveDataModel extends OtherProfileReceiveDataEntity {
  const OtherProfileReceiveDataModel({
    required super.userId,
    required super.isThisYourProfile,
  });

  factory OtherProfileReceiveDataModel.fromJson(Map<String, dynamic> json) {
    return OtherProfileReceiveDataModel(
      userId: _asInt(json['user_id']),
      isThisYourProfile: json['is_this_your_profile'] == true,
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}
