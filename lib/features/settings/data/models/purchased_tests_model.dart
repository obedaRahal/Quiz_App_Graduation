import 'package:quiz_app_grad/features/settings/domain/entity/purchased_tests_entity.dart';

class PurchasedTestsModel extends PurchasedTestsEntity {
  const PurchasedTestsModel({
    required super.success,
    required super.title,
    required super.tests,
    required super.statusCode,
  });

  factory PurchasedTestsModel.fromJson(Map<String, dynamic> json) {
    final rawTests = json['data'] as List<dynamic>? ?? const [];

    return PurchasedTestsModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      tests: rawTests
          .whereType<Map>()
          .map((test) => PurchasedTestModel.fromJson(test.cast<String, dynamic>()))
          .toList(),
      statusCode: _asInt(json['status_code'], fallback: 200),
    );
  }
}

class PurchasedTestModel extends PurchasedTestEntity {
  const PurchasedTestModel({
    required super.id,
    required super.title,
    required super.description,
    required super.interests,
    required super.difficultyLevel,
    required super.averageRating,
    required super.price,
    required super.publishedAt,
    required super.questionCount,
    required super.purchasedAt,
  });

  factory PurchasedTestModel.fromJson(Map<String, dynamic> json) {
    return PurchasedTestModel(
      id: _asInt(json['id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      interests: _asStringList(json['interests']),
      difficultyLevel: json['difficulty_level']?.toString() ?? '',
      averageRating: _asDouble(json['average_rating']),
      price: json['price']?.toString() ?? '0.00',
      publishedAt: json['published_at']?.toString() ?? '',
      questionCount: _asInt(json['question_count']),
      purchasedAt: json['purchased_at']?.toString() ?? '',
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

double _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

List<String> _asStringList(dynamic value) {
  if (value is! List) return const [];

  return value
      .map((item) => item.toString().trim())
      .where((item) => item.isNotEmpty)
      .toList();
}
