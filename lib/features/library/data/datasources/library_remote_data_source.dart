import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/library/data/models/library_response_model.dart';
import 'package:quiz_app_grad/features/library/data/models/library_search_response_model.dart';
import 'package:quiz_app_grad/features/library/domain/entities/library_params.dart';
import 'package:quiz_app_grad/features/library/domain/entities/library_search_params.dart';

abstract class LibraryRemoteDataSource {
  Future<LibraryResponseModel> getLibraryContent(LibraryParams params);
  Future<LibrarySearchResponseModel> searchLibraryContent(
  LibrarySearchParams params,
);
}

class LibraryRemoteDataSourceImpl implements LibraryRemoteDataSource {
  final ApiConsumer apiConsumer;

  const LibraryRemoteDataSourceImpl({
    required this.apiConsumer,
  });

  @override
  Future<LibraryResponseModel> getLibraryContent(LibraryParams params) async {
    debugPrint('================ LibraryRemoteDataSource ================');
    debugPrint('GET: ${EndPoints.libraryShow}');
    debugPrint('Query: ${params.toQuery()}');

    final response = await apiConsumer.get(
      EndPoints.libraryShow,
      queryParameters: params.toQuery(),
    );

    debugPrint('Library response received successfully');

    return LibraryResponseModel.fromJson(response);
  }
  @override
Future<LibrarySearchResponseModel> searchLibraryContent(
  LibrarySearchParams params,
) async {
  debugPrint('================ LibraryRemoteDataSource Search ================');
  debugPrint('GET: ${EndPoints.librarySearch}');
  debugPrint('Query: ${params.toQuery()}');

  final response = await apiConsumer.get(
    EndPoints.librarySearch,
    queryParameters: params.toQuery(),
  );

  debugPrint('Library search response received successfully');

  return LibrarySearchResponseModel.fromJson(response);
}
}