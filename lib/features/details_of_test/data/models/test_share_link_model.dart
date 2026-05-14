import '../../domain/entities/test_share_link_entity.dart';

class TestShareLinkModel {
  final bool success;
  final String title;
  final int statusCode;
  final TestShareLinkDataModel data;

  const TestShareLinkModel({
    required this.success,
    required this.title,
    required this.statusCode,
    required this.data,
  });

  factory TestShareLinkModel.fromJson(Map<String, dynamic> json) {
    return TestShareLinkModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      statusCode: json['status_code'] as int? ?? 0,
      data: TestShareLinkDataModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  TestShareLinkEntity toEntity() {
    return TestShareLinkEntity(
      success: success,
      title: title,
      statusCode: statusCode,
      data: data.toEntity(),
    );
  }
}

class TestShareLinkDataModel {
  final String shareSlug;
  final String shareUrl;

  const TestShareLinkDataModel({
    required this.shareSlug,
    required this.shareUrl,
  });

  factory TestShareLinkDataModel.fromJson(Map<String, dynamic> json) {
    return TestShareLinkDataModel(
      shareSlug: json['share_slug']?.toString() ?? '',
      shareUrl: json['share_url']?.toString() ?? '',
    );
  }

  TestShareLinkDataEntity toEntity() {
    return TestShareLinkDataEntity(
      shareSlug: shareSlug,
      shareUrl: shareUrl,
    );
  }
}