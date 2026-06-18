import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_connections_entity.dart';

class OtherProfileConnectionsResponseModel
    extends OtherProfileConnectionsResponseEntity {
  const OtherProfileConnectionsResponseModel({
    required super.success,
    required super.message,
    required List<OtherProfileConnectionUserModel> super.users,
    required OtherProfileConnectionsMetaModel super.meta,
    required super.statusCode,
  });

  factory OtherProfileConnectionsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OtherProfileConnectionsResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      users: _asMapList(json['data'])
          .map((item) => OtherProfileConnectionUserModel.fromJson(item))
          .toList(),
      meta: OtherProfileConnectionsMetaModel.fromJson(
        (json['meta'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      statusCode: _asInt(json['status_code'], fallback: 200),
    );
  }
}

class OtherProfileConnectionUserModel
    extends OtherProfileConnectionUserEntity {
  const OtherProfileConnectionUserModel({
    required super.userId,
    required super.avatarUrl,
    required super.name,
    required super.isAcademicallyVerified,
    required super.educationLevel,
    required super.viewerIsFollowing,
  });

  factory OtherProfileConnectionUserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OtherProfileConnectionUserModel(
      userId: _asInt(json['user_id']),
      avatarUrl: json['avatar_url']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      isAcademicallyVerified: json['is_academically_verified'] == true,
      educationLevel: json['education_level']?.toString() ?? '',
      viewerIsFollowing: json['viewer_is_following'] == true,
    );
  }
}

class OtherProfileConnectionsMetaModel
    extends OtherProfileConnectionsMetaEntity {
  const OtherProfileConnectionsMetaModel({
    required super.perPage,
    super.nextCursor,
    super.prevCursor,
    required super.hasMorePages,
  });

  factory OtherProfileConnectionsMetaModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OtherProfileConnectionsMetaModel(
      perPage: _asInt(json['per_page'], fallback: 20),
      nextCursor: _asNullableString(json['next_cursor']),
      prevCursor: _asNullableString(json['prev_cursor']),
      hasMorePages: json['has_more_pages'] == true,
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

String? _asNullableString(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();

  if (text.isEmpty || text == 'null') return null;

  return text;
}

List<Map<String, dynamic>> _asMapList(dynamic value) {
  if (value is! List) return [];

  return value
      .whereType<Map>()
      .map((item) => item.cast<String, dynamic>())
      .toList();
}