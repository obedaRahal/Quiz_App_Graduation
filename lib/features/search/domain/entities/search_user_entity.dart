class SearchUsersResponseEntity {
  final List<SearchUserEntity> users;
  final SearchPaginationMetaEntity meta;

  const SearchUsersResponseEntity({required this.users, required this.meta});
}

class SearchUserEntity {
  final int id;
  final String name;
  final String avatarUrl;
  final String academicLevel;
  final bool isAcademicallyVerified;
  final bool viewerIsFollowing;

  const SearchUserEntity({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.academicLevel,
    required this.isAcademicallyVerified,
    required this.viewerIsFollowing,
  });

  SearchUserEntity copyWith({
    int? id,
    String? name,
    String? avatarUrl,
    String? academicLevel,
    bool? isAcademicallyVerified,
    bool? viewerIsFollowing,
  }) {
    return SearchUserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      academicLevel: academicLevel ?? this.academicLevel,
      isAcademicallyVerified:
          isAcademicallyVerified ?? this.isAcademicallyVerified,
      viewerIsFollowing: viewerIsFollowing ?? this.viewerIsFollowing,
    );
  }
}

class SearchPaginationMetaEntity {
  final int perPage;
  final String? nextCursor;
  final String? previousCursor;
  final bool hasMorePages;

  const SearchPaginationMetaEntity({
    required this.perPage,
    required this.nextCursor,
    required this.previousCursor,
    required this.hasMorePages,
  });
}
