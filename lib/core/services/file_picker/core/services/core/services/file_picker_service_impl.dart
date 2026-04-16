import 'package:file_picker/file_picker.dart';
import 'package:quiz_app_grad/core/services/file_picker/core/services/file_picker_service.dart';

class FilePickerServiceImpl implements FilePickerService {
  @override
  Future<String?> pickSingleImagePath() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return null;

    return result.files.single.path;
  }

  @override
  Future<List<String>> pickMultipleImagePaths() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result == null || result.files.isEmpty) return const [];

    return result.files
        .map((file) => file.path)
        .whereType<String>()
        .toList();
  }

  @override
  Future<String?> pickSingleFilePath({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
  }) async {
    final result = await FilePicker.pickFiles(
      type: type,
      allowMultiple: false,
      allowedExtensions: allowedExtensions,
    );

    if (result == null || result.files.isEmpty) return null;

    return result.files.single.path;
  }
}