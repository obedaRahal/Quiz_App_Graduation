import '../../domain/entities/test_like_action_entity.dart';

class TestLikeActionModel {
  final bool success;
  final String title;
  final TestLikeActionDataModel data;
  final int statusCode;

  const TestLikeActionModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory TestLikeActionModel.fromJson(Map<String, dynamic> json) {
    return TestLikeActionModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      data: TestLikeActionDataModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
      statusCode: json['status_code'] as int? ?? 0,
    );
  }

  TestLikeActionEntity toEntity() {
    return TestLikeActionEntity(
      success: success,
      title: title,
      data: data.toEntity(),
      statusCode: statusCode,
    );
  }
}

class TestLikeActionDataModel {
  final bool hasLiked;
  final bool stateChanged;

  const TestLikeActionDataModel({
    required this.hasLiked,
    required this.stateChanged,
  });

  factory TestLikeActionDataModel.fromJson(Map<String, dynamic> json) {
    return TestLikeActionDataModel(
      hasLiked: json['has_liked'] as bool? ?? false,
      stateChanged: json['state_changed'] as bool? ?? false,
    );
  }

  TestLikeActionDataEntity toEntity() {
    return TestLikeActionDataEntity(
      hasLiked: hasLiked,
      stateChanged: stateChanged,
    );
  }
}