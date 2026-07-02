

import 'package:quiz_app_grad/features/content_details/domain/repositories/other_content_details_repository.dart' show OtherContentDetailsRepository;

class DownloadOtherContentUseCase {
  final OtherContentDetailsRepository repository;

  const DownloadOtherContentUseCase(this.repository);

  Future<void> call(int contentId) {
    return repository.downloadContent(contentId);
  }
}