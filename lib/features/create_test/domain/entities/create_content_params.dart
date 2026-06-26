import 'package:file_picker/file_picker.dart';

class CreateContentParams {
  final String title;
  final String description;
  final String contentKind; // صور مجمعة / ملف
  final List<PlatformFile> assets;
  final List<int> interestIds;
  final String targetLevel;
  final String visibilityType; // عام / خاص

  const CreateContentParams({
    required this.title,
    required this.description,
    required this.contentKind,
    required this.assets,
    required this.interestIds,
    required this.targetLevel,
    required this.visibilityType,
  });
}