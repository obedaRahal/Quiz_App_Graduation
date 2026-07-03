import 'package:quiz_app_grad/features/content_details/domain/entities/my_content_details/my_content_details_entity.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/my_content_details/my_content_details_params.dart';

import '../../domain/repositories/my_content_details_repository.dart';
import '../datasources/my_content_details_remote_data_source.dart';

class MyContentDetailsRepositoryImpl implements MyContentDetailsRepository {
  final MyContentDetailsRemoteDataSource remoteDataSource;

  const MyContentDetailsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<MyContentDetailsEntity> getMyPublicContentDetails(
    MyContentDetailsParams params,
  ) {
    return remoteDataSource.getMyPublicContentDetails(params);
  }
}