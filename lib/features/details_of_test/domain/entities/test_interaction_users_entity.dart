class TestInteractionUsersEntity {
  final bool success;
  final String message;
  final List<TestInteractionUserEntity> users;
  final TestInteractionUsersMetaEntity meta;
  final int statusCode;

  const TestInteractionUsersEntity({
    required this.success,
    required this.message,
    required this.users,
    required this.meta,
    required this.statusCode,
  });

  TestInteractionUsersEntity copyWith({
    bool? success,
    String? message,
    List<TestInteractionUserEntity>? users,
    TestInteractionUsersMetaEntity? meta,
    int? statusCode,
  }) {
    return TestInteractionUsersEntity(
      success: success ?? this.success,
      message: message ?? this.message,
      users: users ?? this.users,
      meta: meta ?? this.meta,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

class TestInteractionUserEntity {
  final int userId;
  final String name;
  final String avatarUrl;
  final String educationLevel;
  final bool isAcademicallyVerified;
  final bool viewerIsFollowing;

  const TestInteractionUserEntity({
    required this.userId,
    required this.name,
    required this.avatarUrl,
    required this.educationLevel,
    required this.isAcademicallyVerified,
    required this.viewerIsFollowing,
  });

  TestInteractionUserEntity copyWith({
    int? userId,
    String? name,
    String? avatarUrl,
    String? educationLevel,
    bool? isAcademicallyVerified,
    bool? viewerIsFollowing,
  }) {
    return TestInteractionUserEntity(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      educationLevel: educationLevel ?? this.educationLevel,
      isAcademicallyVerified:
          isAcademicallyVerified ?? this.isAcademicallyVerified,
      viewerIsFollowing: viewerIsFollowing ?? this.viewerIsFollowing,
    );
  }
}

class TestInteractionUsersMetaEntity {
  final int perPage;
  final String? nextCursor;
  final String? prevCursor;
  final bool hasMorePages;

  const TestInteractionUsersMetaEntity({
    required this.perPage,
    required this.nextCursor,
    required this.prevCursor,
    required this.hasMorePages,
  });
}