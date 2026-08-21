import 'package:file_picker/file_picker.dart';

class AiQuestionGenerationParams {
  final String sourceType;
  final int questionCount;
  final String difficultyLevel;
  final String language;
  final List<PlatformFile> files;
  final void Function(int sent, int total)? onSendProgress;

  const AiQuestionGenerationParams({
    required this.sourceType,
    required this.questionCount,
    required this.difficultyLevel,
    required this.language,
    required this.files,
    this.onSendProgress,
  });
}
