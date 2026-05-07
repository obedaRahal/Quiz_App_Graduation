import '../../domain/entities/test_bookmark_action_entity.dart';

class TestBookmarkActionModel {
  final bool success;
  final String title;
  final TestBookmarkActionDataModel data;
  final int statusCode;

  const TestBookmarkActionModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory TestBookmarkActionModel.fromJson(Map<String, dynamic> json) {
    return TestBookmarkActionModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      data: TestBookmarkActionDataModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
      statusCode: json['status_code'] as int? ?? 0,
    );
  }

  TestBookmarkActionEntity toEntity() {
    return TestBookmarkActionEntity(
      success: success,
      title: title,
      data: data.toEntity(),
      statusCode: statusCode,
    );
  }
}

class TestBookmarkActionDataModel {
  final bool hasBookmarked;
  final bool stateChanged;

  const TestBookmarkActionDataModel({
    required this.hasBookmarked,
    required this.stateChanged,
  });

  factory TestBookmarkActionDataModel.fromJson(Map<String, dynamic> json) {
    return TestBookmarkActionDataModel(
      hasBookmarked: json['has_bookmarked'] as bool? ?? false,
      stateChanged: json['state_changed'] as bool? ?? false,
    );
  }

  TestBookmarkActionDataEntity toEntity() {
    return TestBookmarkActionDataEntity(
      hasBookmarked: hasBookmarked,
      stateChanged: stateChanged,
    );
  }
}