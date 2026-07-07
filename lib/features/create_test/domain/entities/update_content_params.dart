import 'package:file_picker/file_picker.dart';

class UpdateContentParams {
  final int contentId;
  final String title;
  final String description;
  final List<int> interestIds;
  final String targetLevel;
  final String visibilityType; // عام / خاص
  final List<PlatformFile> mediaFiles;

  const UpdateContentParams({
    required this.contentId,
    required this.title,
    required this.description,
    required this.interestIds,
    required this.targetLevel,
    required this.visibilityType,
    this.mediaFiles = const [],
  });
}