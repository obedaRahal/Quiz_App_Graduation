import 'package:quiz_app_grad/features/search/domain/entities/search_user_entity.dart';

class SearchUsersResponseModel extends SearchUsersResponseEntity {
  const SearchUsersResponseModel({required super.users, required super.meta});

  factory SearchUsersResponseModel.fromJson(Map<String, dynamic> json) {
    final data = _parseMap(json['data']);
    final usersJson = data['users'];
    final metaJson = _parseMap(data['meta']);

    final users = usersJson is List
        ? usersJson
              .whereType<Map<String, dynamic>>()
              .map(SearchUserModel.fromJson)
              .toList()
        : <SearchUserModel>[];

    return SearchUsersResponseModel(
      users: users,
      meta: SearchPaginationMetaModel.fromJson(metaJson),
    );
  }

  static Map<String, dynamic> _parseMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }
}


class SearchUserModel extends SearchUserEntity {
  const SearchUserModel({
    required super.id,
    required super.name,
    required super.avatarUrl,
    required super.academicLevel,
    required super.isAcademicallyVerified,
    required super.viewerIsFollowing,
  });

  factory SearchUserModel.fromJson(Map<String, dynamic> json) {
    return SearchUserModel(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString() ?? '',
      academicLevel: json['academic_level']?.toString() ?? '',
      isAcademicallyVerified: json['is_academically_verified'] == true,
      viewerIsFollowing: json['viewer_is_following'] == true,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class SearchPaginationMetaModel extends SearchPaginationMetaEntity {
  const SearchPaginationMetaModel({
    required super.perPage,
    required super.nextCursor,
    required super.previousCursor,
    required super.hasMorePages,
  });

  factory SearchPaginationMetaModel.fromJson(Map<String, dynamic> json) {
    return SearchPaginationMetaModel(
      perPage: _parseInt(json['per_page']),
      nextCursor: _parseNullableString(json['next_cursor']),
      previousCursor: _parseNullableString(json['previous_cursor']),
      hasMorePages: json['has_more_pages'] == true,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String? _parseNullableString(dynamic value) {
    if (value == null) {
      return null;
    }

    final result = value.toString().trim();

    if (result.isEmpty) {
      return null;
    }

    return result;
  }
}
