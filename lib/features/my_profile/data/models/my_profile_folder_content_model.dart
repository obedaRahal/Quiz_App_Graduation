import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_folder_content_entity.dart';

class MyProfileFolderContentModel {
  final bool success;
  final String title;
  final List<MyProfileFolderContentTestModel> data;
  final int statusCode;

  const MyProfileFolderContentModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory MyProfileFolderContentModel.fromJson(Map<String, dynamic> json) {
    return MyProfileFolderContentModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      data: _asMapList(json['data'])
          .map((item) => MyProfileFolderContentTestModel.fromJson(item))
          .toList(),
      statusCode: _asInt(json['status_code']),
    );
  }

  MyProfileFolderContentEntity toEntity() {
    return MyProfileFolderContentEntity(
      success: success,
      title: title,
      data: data.map((item) => item.toEntity()).toList(),
      statusCode: statusCode,
    );
  }
}

class MyProfileFolderContentTestModel {
  final int id;
  final String title;
  final String description;
  final List<String> interests;
  final String difficultyLevel;
  final int questionCount;
  final double averageRating;
  final double price;
  final String publishedAt;
  final String testType;

  const MyProfileFolderContentTestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.interests,
    required this.difficultyLevel,
    required this.questionCount,
    required this.averageRating,
    required this.price,
    required this.publishedAt,
    required this.testType,
  });

  factory MyProfileFolderContentTestModel.fromJson(Map<String, dynamic> json) {
    return MyProfileFolderContentTestModel(
      id: _asInt(json['id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      interests: _asDynamicList(json['interests'])
          .map((item) => item.toString())
          .toList(),
      difficultyLevel: json['difficulty_level']?.toString() ?? '',
      questionCount: _asInt(json['question_count']),
      averageRating: _asDouble(json['average_rating']),
      price: _asDouble(json['price']),
      publishedAt: json['published_at']?.toString() ?? '',
      testType: json['test_type']?.toString() ?? '',
    );
  }

  MyProfileFolderContentTestEntity toEntity() {
    return MyProfileFolderContentTestEntity(
      id: id,
      title: title,
      description: description,
      interests: interests,
      difficultyLevel: difficultyLevel,
      questionCount: questionCount,
      averageRating: averageRating,
      price: price,
      publishedAt: publishedAt,
      testType: testType,
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

List<dynamic> _asDynamicList(dynamic value) {
  if (value is List) return value;
  return [];
}

List<Map<String, dynamic>> _asMapList(dynamic value) {
  if (value is! List) return [];

  return value
      .whereType<Map>()
      .map((item) => item.cast<String, dynamic>())
      .toList();
}