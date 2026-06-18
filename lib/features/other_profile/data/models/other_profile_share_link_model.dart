import 'package:quiz_app_grad/core/utils/compact_count_formatter.dart';

import '../../domain/entities/other_profile_share_link_entity.dart';

class OtherProfileShareLinkModel extends OtherProfileShareLinkEntity {
  const OtherProfileShareLinkModel({
    required super.success,
    required super.title,
    required OtherProfileShareLinkDataModel super.data,
    required super.statusCode,
  });

  factory OtherProfileShareLinkModel.fromJson(Map<String, dynamic> json) {
    return OtherProfileShareLinkModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      data: OtherProfileShareLinkDataModel.fromJson(
        (json['data'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      statusCode: parseCompactCount(json['status_code']),
    );
  }
}

class OtherProfileShareLinkDataModel extends OtherProfileShareLinkDataEntity {
  const OtherProfileShareLinkDataModel({
    required super.shareSlug,
    required super.shareUrl,
  });

  factory OtherProfileShareLinkDataModel.fromJson(Map<String, dynamic> json) {
    return OtherProfileShareLinkDataModel(
      shareSlug: json['share_slug']?.toString() ?? '',
      shareUrl: json['share_url']?.toString() ?? '',
    );
  }
}
