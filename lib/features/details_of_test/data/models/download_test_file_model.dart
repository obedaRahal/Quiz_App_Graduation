import '../../domain/entities/download_test_file_entity.dart';

class DownloadTestFileModel {
  final String filePath;
  final String fileName;

  const DownloadTestFileModel({
    required this.filePath,
    required this.fileName,
  });

  DownloadTestFileEntity toEntity() {
    return DownloadTestFileEntity(
      filePath: filePath,
      fileName: fileName,
    );
  }
}