import '../../domain/entities/shared_test_link_entity.dart';

class SharedTestLinkModel {
  final bool success;
  final String title;
  final int statusCode;
  final SharedTestLinkDataModel data;

  const SharedTestLinkModel({
    required this.success,
    required this.title,
    required this.statusCode,
    required this.data,
  });

  factory SharedTestLinkModel.fromJson(Map<String, dynamic> json) {
    return SharedTestLinkModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      statusCode: json['status_code'] as int? ?? 0,
      data: SharedTestLinkDataModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  SharedTestLinkEntity toEntity() {
    return SharedTestLinkEntity(
      success: success,
      title: title,
      statusCode: statusCode,
      data: data.toEntity(),
    );
  }
}

class SharedTestLinkDataModel {
  final int testId;
  final bool isOwner;

  const SharedTestLinkDataModel({
    required this.testId,
    required this.isOwner,
  });

  factory SharedTestLinkDataModel.fromJson(Map<String, dynamic> json) {
    return SharedTestLinkDataModel(
      testId: json['test_id'] as int? ?? 0,
      isOwner: json['is_owner'] as bool? ?? false,
    );
  }

  SharedTestLinkDataEntity toEntity() {
    return SharedTestLinkDataEntity(
      testId: testId,
      isOwner: isOwner,
    );
  }
}