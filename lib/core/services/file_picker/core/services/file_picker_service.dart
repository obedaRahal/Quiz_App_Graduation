import 'package:file_picker/file_picker.dart';

abstract class FilePickerService {
  Future<String?> pickSingleImagePath();

  Future<List<String>> pickMultipleImagePaths();

  Future<String?> pickSingleFilePath({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
  });
}