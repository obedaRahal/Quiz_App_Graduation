import '../../domain/entities/other_content_details_entity.dart';
import 'other_content_basic_info_model.dart';
import 'other_content_publisher_model.dart';
import 'other_content_viewer_state_model.dart';

class OtherContentDetailsModel extends OtherContentDetailsEntity {
  const OtherContentDetailsModel({
    required super.success,
    required super.title,
    required super.basicInfo,
    required super.publisher,
    required super.viewerState,
    required super.statusCode,
  });

  factory OtherContentDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return OtherContentDetailsModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      basicInfo: OtherContentBasicInfoModel.fromJson(
        data['basic_info'] as Map<String, dynamic>? ?? {},
      ),
      publisher: OtherContentPublisherModel.fromJson(
        data['publisher'] as Map<String, dynamic>? ?? {},
      ),
      viewerState: OtherContentViewerStateModel.fromJson(
        data['viewer_state'] as Map<String, dynamic>? ?? {},
      ),
      statusCode: json['status_code'] ?? 0,
    );
  }
}