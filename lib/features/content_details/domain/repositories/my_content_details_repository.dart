

import 'package:quiz_app_grad/features/content_details/domain/entities/my_content_details/my_content_details_entity.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/my_content_details/my_content_details_params.dart';

abstract class MyContentDetailsRepository {
  Future<MyContentDetailsEntity> getMyPublicContentDetails(
    MyContentDetailsParams params,
  );
}