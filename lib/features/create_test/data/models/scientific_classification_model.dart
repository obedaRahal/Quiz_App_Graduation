import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/scientific_classification_entity.dart';

class ScientificClassificationsResponseModel {
  final bool success;
  final String title;
  final List<ScientificClassificationGroupModel> data;
  final int statusCode;

  const ScientificClassificationsResponseModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory ScientificClassificationsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ScientificClassificationsResponseModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => ScientificClassificationGroupModel.fromJson(item))
          .toList(),
      statusCode: json['status_code'] is int
          ? json['status_code']
          : int.tryParse(json['status_code']?.toString() ?? '') ?? 0,
    );
  }

  ScientificClassificationsResponseEntity toEntity() {
    return ScientificClassificationsResponseEntity(
      success: success,
      title: title,
      groups: data.map((item) => item.toEntity()).toList(),
      statusCode: statusCode,
    );
  }
}

class ScientificClassificationGroupModel {
  final int id;
  final String title;
  final List<ScientificInterestModel> interests;

  const ScientificClassificationGroupModel({
    required this.id,
    required this.title,
    required this.interests,
  });

  factory ScientificClassificationGroupModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ScientificClassificationGroupModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      interests: (json['interests'] as List? ?? [])
          .map((item) => ScientificInterestModel.fromJson(item))
          .toList(),
    );
  }

  ScientificClassificationGroupEntity toEntity() {
    return ScientificClassificationGroupEntity(
      id: id,
      title: title,
      interests: interests.map((item) => item.toEntity()).toList(),
    );
  }
}

class ScientificInterestModel {
  final int id;
  final String name;
  final String iconSvg;
  final String iconColor;

  const ScientificInterestModel({
    required this.id,
    required this.name,
    required this.iconSvg,
    required this.iconColor,
  });

  factory ScientificInterestModel.fromJson(Map<String, dynamic> json) {
    return ScientificInterestModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      iconSvg: _normalizeIconUrl(json['icon_svg']?.toString() ?? ''),
      iconColor: json['icon_color']?.toString() ?? '#5583FF',
    );
  }

  ScientificInterestEntity toEntity() {
    return ScientificInterestEntity(
      id: id,
      name: name,
      iconSvg: iconSvg,
      iconColor: iconColor,
    );
  }

  static String _normalizeIconUrl(String rawUrl) {
    if (rawUrl.trim().isEmpty) return '';

    final iconUri = Uri.tryParse(rawUrl);
    if (iconUri == null) return rawUrl;

    final apiUri = Uri.parse(EndPoints.baseUrl);

    final isLocalhost =
        iconUri.host == 'localhost' || iconUri.host == '127.0.0.1';

    if (!isLocalhost) return rawUrl;

    return iconUri.replace(
      scheme: apiUri.scheme,
      host: apiUri.host,
      port: apiUri.hasPort ? apiUri.port : null,
    ).toString();
  }
}