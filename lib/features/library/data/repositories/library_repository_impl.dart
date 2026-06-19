import 'package:flutter/foundation.dart';

import '../../domain/entities/library_params.dart';
import '../../domain/entities/library_response_entity.dart';
import '../../domain/repositories/library_repository.dart';
import '../datasources/library_remote_data_source.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryRemoteDataSource remoteDataSource;

  const LibraryRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<LibraryResponseEntity> getLibraryContent(LibraryParams params) async {
    debugPrint('================ LibraryRepositoryImpl ================');
    debugPrint('tab: ${params.tab.apiValue}, perPage: ${params.perPage}, cursor: ${params.cursor}');

    return remoteDataSource.getLibraryContent(params);
  }
}