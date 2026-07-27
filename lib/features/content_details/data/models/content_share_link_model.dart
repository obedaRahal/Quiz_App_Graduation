import 'package:quiz_app_grad/features/content_details/domain/entities/content_share_link_entity.dart';

class ContentShareLinkModel {
  final bool success;
  final String title;
  final int statusCode;
  final String shareSlug;
  final String shareUrl;

  const ContentShareLinkModel({
    required this.success,
    required this.title,
    required this.statusCode,
    required this.shareSlug,
    required this.shareUrl,
  });

  factory ContentShareLinkModel.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']);

    return ContentShareLinkModel(
      success: _asBool(json['success']),
      title: _asString(json['title']),
      statusCode: _asInt(json['status_code']),
      shareSlug: _asString(data['share_slug']),
      shareUrl: _asString(data['share_url']),
    );
  }

  ContentShareLinkEntity toEntity() {
    return ContentShareLinkEntity(
      success: success,
      title: title,
      statusCode: statusCode,
      shareSlug: shareSlug,
      shareUrl: shareUrl,
    );
  }
}

class SharedContentLinkModel {
  final bool success;
  final String title;
  final int statusCode;
  final int materialId;
  final bool isOwner;

  const SharedContentLinkModel({
    required this.success,
    required this.title,
    required this.statusCode,
    required this.materialId,
    required this.isOwner,
  });

  factory SharedContentLinkModel.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']);

    return SharedContentLinkModel(
      success: _asBool(json['success']),
      title: _asString(json['title']),
      statusCode: _asInt(json['status_code']),
      materialId: _asInt(data['material_id']),
      isOwner: _asBool(data['is_owner']),
    );
  }

  SharedContentLinkEntity toEntity() {
    return SharedContentLinkEntity(
      success: success,
      title: title,
      statusCode: statusCode,
      materialId: materialId,
      isOwner: isOwner,
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  return value is Map<String, dynamic> ? value : const <String, dynamic>{};
}

String _asString(dynamic value) => value?.toString().trim() ?? '';

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;

  final normalized = value?.toString().trim().toLowerCase();
  return normalized == 'true' || normalized == '1';
}
