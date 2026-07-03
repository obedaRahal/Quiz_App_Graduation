import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_entity.dart';

class MyProfilePersonalInfoModel extends MyProfileEntity {
  const MyProfilePersonalInfoModel({
    required super.userId,
    required super.name,
    required super.email,
    required super.phone,
    required super.governorate,
    required super.gender,
    required super.birthDate,
    required super.avatarUrl,
    required super.coverUrl,
    required super.isAcademicallyVerified,
    required super.testsCount,
    required super.followersCount,
    required super.followingCount,
    required super.academicInformation,
    required super.scientificInterests,
  });

  factory MyProfilePersonalInfoModel.fromJson({
    required int userId,
    required Map<String, dynamic> json,
  }) {
    final data = (json['data'] as Map?)?.cast<String, dynamic>() ?? {};
    final header = (data['header'] as Map?)?.cast<String, dynamic>() ?? {};
    final personal =
        (data['personal_information'] as Map?)?.cast<String, dynamic>() ?? {};
    final academic =
        (data['academic_information'] as Map?)?.cast<String, dynamic>() ?? {};

    return MyProfilePersonalInfoModel(
      userId: userId,

      name: personal['name']?.toString() ?? header['name']?.toString() ?? '',
      email: personal['email']?.toString() ?? '',
      phone: personal['phone']?.toString() ?? '',
      governorate: personal['governorate']?.toString() ?? '',
      gender: personal['gender']?.toString() ?? '',
      birthDate: personal['birth_date']?.toString() ?? '',

      avatarUrl: header['avatar_url']?.toString() ?? '',
      coverUrl: header['cover_url']?.toString() ?? '',
      isAcademicallyVerified: header['is_academically_verified'] == true,

      testsCount: _asInt(header['published_tests_count']).toString(),
      followersCount: _asInt(header['followers_count']).toString(),
      followingCount: _asInt(header['following_count']).toString(),

      academicInformation: MyProfileAcademicInformationModel.fromJson(
        academic,
      ),
      scientificInterests: _asMapList(data['scientific_interests'])
          .map((item) => MyProfileScientificInterestModel.fromJson(item))
          .toList(),
    );
  }
}

class MyProfileAcademicInformationModel
    extends MyProfileAcademicInformationEntity {
  const MyProfileAcademicInformationModel({
    required super.educationLevel,
    required super.universityName,
    required super.department,
    super.universityYear,
    super.schoolStage,
  });

  factory MyProfileAcademicInformationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyProfileAcademicInformationModel(
      educationLevel: json['education_level']?.toString() ?? '',
      universityName: json['university_name']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
      universityYear: _asNullableString(json['university_year']),
      schoolStage: _asNullableString(json['school_stage']),
    );
  }
}

class MyProfileScientificInterestModel
    extends MyProfileScientificInterestEntity {
  const MyProfileScientificInterestModel({
    required super.id,
    required super.name,
  });

  factory MyProfileScientificInterestModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyProfileScientificInterestModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is double) return value.toInt();

  if (value is String) {
    final text = value.trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return fallback;
    return int.tryParse(text) ?? fallback;
  }

  return fallback;
}

String? _asNullableString(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();

  if (text.isEmpty || text.toLowerCase() == 'null') return null;

  return text;
}

List<Map<String, dynamic>> _asMapList(dynamic value) {
  if (value is! List) return [];

  return value
      .whereType<Map>()
      .map((item) => item.cast<String, dynamic>())
      .toList();
}