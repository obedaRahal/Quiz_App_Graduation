import 'other_content_basic_info_entity.dart';
import 'other_content_publisher_entity.dart';
import 'other_content_viewer_state_entity.dart';

class OtherContentDetailsEntity {
  final bool success;
  final String title;
  final OtherContentBasicInfoEntity basicInfo;
  final OtherContentPublisherEntity publisher;
  final OtherContentViewerStateEntity viewerState;
  final int statusCode;

  const OtherContentDetailsEntity({
    required this.success,
    required this.title,
    required this.basicInfo,
    required this.publisher,
    required this.viewerState,
    required this.statusCode,
  });
}