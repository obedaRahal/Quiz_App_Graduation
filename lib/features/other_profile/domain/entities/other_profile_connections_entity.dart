class OtherProfileConnectionsResponseEntity {
  final bool success;
  final String message;
  final List<OtherProfileConnectionUserEntity> users;
  final OtherProfileConnectionsMetaEntity meta;
  final int statusCode;

  const OtherProfileConnectionsResponseEntity({
    required this.success,
    required this.message,
    required this.users,
    required this.meta,
    required this.statusCode,
  });
}

class OtherProfileConnectionUserEntity {
  final int userId;
  final String avatarUrl;
  final String name;
  final bool isAcademicallyVerified;
  final String educationLevel;
  final bool viewerIsFollowing;

  const OtherProfileConnectionUserEntity({
    required this.userId,
    required this.avatarUrl,
    required this.name,
    required this.isAcademicallyVerified,
    required this.educationLevel,
    required this.viewerIsFollowing,
  });

  OtherProfileConnectionUserEntity copyWith({
    int? userId,
    String? avatarUrl,
    String? name,
    bool? isAcademicallyVerified,
    String? educationLevel,
    bool? viewerIsFollowing,
  }) {
    return OtherProfileConnectionUserEntity(
      userId: userId ?? this.userId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      name: name ?? this.name,
      isAcademicallyVerified:
          isAcademicallyVerified ?? this.isAcademicallyVerified,
      educationLevel: educationLevel ?? this.educationLevel,
      viewerIsFollowing: viewerIsFollowing ?? this.viewerIsFollowing,
    );
  }
}

class OtherProfileConnectionsMetaEntity {
  final int perPage;
  final String? nextCursor;
  final String? prevCursor;
  final bool hasMorePages;

  const OtherProfileConnectionsMetaEntity({
    required this.perPage,
    this.nextCursor,
    this.prevCursor,
    required this.hasMorePages,
  });
}