// import 'package:file_picker/file_picker.dart';

// class LibraryFilePickerHelper {
//   static Future<PlatformFile?> pickSingleFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       allowMultiple: false,
//       type: FileType.custom,
//       allowedExtensions: [
//         'pdf',
//         'doc',
//         'docx',
//         'ppt',
//         'pptx',
//       ],
//     );

//     if (result == null || result.files.isEmpty) {
//       return null;
//     }

//     return result.files.first;
//   }
// } 
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class LibraryFilePickerHelper {
  static Future<PlatformFile?> pickSingleFile() async {
    try {
      debugPrint('============ PICK FILE START ============');

      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: const [
          'pdf',
          'doc',
          'docx',
          'ppt',
          'pptx',
        ],
        withData: false,
      );

      debugPrint('============ PICK FILE RESULT ============');
      debugPrint('result null: ${result == null}');
      debugPrint('files count: ${result?.files.length ?? 0}');

      if (result == null || result.files.isEmpty) {
        return null;
      }

      final file = result.files.first;

      debugPrint('file name: ${file.name}');
      debugPrint('file path: ${file.path}');
      debugPrint('file size: ${file.size}');
      debugPrint('=========================================');

      if (file.path == null || file.path!.trim().isEmpty) {
        debugPrint('file path is null or empty');
        return null;
      }

      return file;
    } catch (error, stackTrace) {
      debugPrint('pickSingleFile error: $error');
      debugPrint('pickSingleFile stackTrace: $stackTrace');
      return null;
    }
  }
}