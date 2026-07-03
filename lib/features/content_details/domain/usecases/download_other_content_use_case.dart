

import 'package:quiz_app_grad/features/content_details/domain/repositories/other_content_details_repository.dart' show OtherContentDetailsRepository;

class DownloadOtherContentUseCase {
  final OtherContentDetailsRepository repository;

  DownloadOtherContentUseCase(this.repository);

  Future<String> call(int contentId) {
    return repository.downloadContent(contentId);
  }
}