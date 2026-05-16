import '../../domain/entities/test_interaction_users_entity.dart';

class TestInteractionUsersModel {
  final bool success;
  final String message;
  final List<TestInteractionUserModel> users;
  final TestInteractionUsersMetaModel meta;
  final int statusCode;

  const TestInteractionUsersModel({
    required this.success,
    required this.message,
    required this.users,
    required this.meta,
    required this.statusCode,
  });

  factory TestInteractionUsersModel.fromJson(Map<String, dynamic> json) {
    final usersJson = json['data'] as List<dynamic>? ?? [];

    return TestInteractionUsersModel(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      users: usersJson
          .map(
            (item) => TestInteractionUserModel.fromJson(
              item as Map<String, dynamic>? ?? {},
            ),
          )
          .toList(),
      meta: TestInteractionUsersMetaModel.fromJson(
        json['meta'] as Map<String, dynamic>? ?? {},
      ),
      statusCode: json['status_code'] as int? ?? 0,
    );
  }

  TestInteractionUsersEntity toEntity() {
    return TestInteractionUsersEntity(
      success: success,
      message: message,
      users: users.map((item) => item.toEntity()).toList(),
      meta: meta.toEntity(),
      statusCode: statusCode,
    );
  }
}

class TestInteractionUserModel {
  final int userId;
  final String name;
  final String avatarUrl;
  final String educationLevel;
  final bool isAcademicallyVerified;
  final bool viewerIsFollowing;

  const TestInteractionUserModel({
    required this.userId,
    required this.name,
    required this.avatarUrl,
    required this.educationLevel,
    required this.isAcademicallyVerified,
    required this.viewerIsFollowing,
  });

  factory TestInteractionUserModel.fromJson(Map<String, dynamic> json) {
    return TestInteractionUserModel(
      userId: json['user_id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString() ?? '',
      educationLevel: json['education_level']?.toString() ?? '',
      isAcademicallyVerified:
          json['is_academically_verified'] as bool? ?? false,
      viewerIsFollowing: json['viewer_is_following'] as bool? ?? false,
    );
  }

  TestInteractionUserEntity toEntity() {
    return TestInteractionUserEntity(
      userId: userId,
      name: name,
      avatarUrl: avatarUrl,
      educationLevel: educationLevel,
      isAcademicallyVerified: isAcademicallyVerified,
      viewerIsFollowing: viewerIsFollowing,
    );
  }
}

class TestInteractionUsersMetaModel {
  final int perPage;
  final String? nextCursor;
  final String? prevCursor;
  final bool hasMorePages;

  const TestInteractionUsersMetaModel({
    required this.perPage,
    required this.nextCursor,
    required this.prevCursor,
    required this.hasMorePages,
  });

  factory TestInteractionUsersMetaModel.fromJson(Map<String, dynamic> json) {
    return TestInteractionUsersMetaModel(
      perPage: json['per_page'] as int? ?? 20,
      nextCursor: json['next_cursor']?.toString(),
      prevCursor: json['prev_cursor']?.toString(),
      hasMorePages: json['has_more_pages'] as bool? ?? false,
    );
  }

  TestInteractionUsersMetaEntity toEntity() {
    return TestInteractionUsersMetaEntity(
      perPage: perPage,
      nextCursor: nextCursor,
      prevCursor: prevCursor,
      hasMorePages: hasMorePages,
    );
  }
}