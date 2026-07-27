import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/content_details/data/models/content_share_link_model.dart';
import 'package:quiz_app_grad/features/content_details/data/models/follow_publisher_response_model.dart';
import 'package:quiz_app_grad/features/content_details/data/models/similar_content_response_model.dart';
import 'package:quiz_app_grad/features/content_details/data/models/unfollow_publisher_response_model.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/similar_content_params.dart';

import '../../domain/entities/other_content_details_params.dart';
import '../models/other_content_details_model.dart';

abstract class OtherContentDetailsRemoteDataSource {
  Future<OtherContentDetailsModel> getOtherContentDetails(
    OtherContentDetailsParams params,
  );
  Future<String> downloadContent(int contentId);
  Future<SimilarContentResponseModel> getSimilarContent(
    SimilarContentParams params,
  );
  Future<FollowPublisherResponseModel> followPublisher(int publisherId);
  Future<UnfollowPublisherResponseModel> unfollowPublisher(int publisherId);
  Future<ContentShareLinkModel> getContentShareLink(int contentId);
  Future<SharedContentLinkModel> resolveSharedContentLink(String slug);
}

class OtherContentDetailsRemoteDataSourceImpl
    implements OtherContentDetailsRemoteDataSource {
  final ApiConsumer apiConsumer;

  const OtherContentDetailsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<OtherContentDetailsModel> getOtherContentDetails(
    OtherContentDetailsParams params,
  ) async {
    debugPrint(
      '================ OtherContentDetailsRemoteDataSource ================',
    );
    debugPrint('GET: ${EndPoints.otherContentDetails(params.contentId)}');

    final response = await apiConsumer.get(
      EndPoints.otherContentDetails(params.contentId),
    );

    debugPrint('Other content details response received successfully');

    return OtherContentDetailsModel.fromJson(response);
  }

  @override
  Future<SimilarContentResponseModel> getSimilarContent(
    SimilarContentParams params,
  ) async {
    final interestQuery = params.interestIds
        .take(3)
        .map((id) => 'interest_ids[]=$id')
        .join('&');

    final cursorQuery = params.cursor != null && params.cursor!.isNotEmpty
        ? '&cursor=${Uri.encodeComponent(params.cursor!)}'
        : '';

    final url =
        '${EndPoints.similarContent(params.contentId)}?$interestQuery&per_page=${params.perPage}$cursorQuery';

    debugPrint(
      '================ SimilarContentRemoteDataSource ================',
    );
    debugPrint('GET: $url');
    debugPrint('content id: ${params.contentId}');
    debugPrint('interest ids: ${params.interestIds}');

    final response = await apiConsumer.get(url);

    debugPrint('Similar content response received successfully');

    return SimilarContentResponseModel.fromJson(response);
  }

  @override
  Future<FollowPublisherResponseModel> followPublisher(int publisherId) async {
    debugPrint(
      '================ FollowPublisherRemoteDataSource ================',
    );
    debugPrint('POST: ${EndPoints.followPublisher(publisherId)}');

    final response = await apiConsumer.post(
      EndPoints.followPublisher(publisherId),
    );

    debugPrint('Follow publisher response received successfully');

    return FollowPublisherResponseModel.fromJson(response);
  }

  @override
  Future<UnfollowPublisherResponseModel> unfollowPublisher(
    int publisherId,
  ) async {
    debugPrint(
      '================ UnfollowPublisherRemoteDataSource ================',
    );
    debugPrint('DELETE: ${EndPoints.unfollowPublisher(publisherId)}');

    final response = await apiConsumer.delete(
      EndPoints.unfollowPublisher(publisherId),
    );

    debugPrint('Unfollow publisher response received successfully');

    return UnfollowPublisherResponseModel.fromJson(response);
  }

  @override
  Future<ContentShareLinkModel> getContentShareLink(int contentId) async {
    final endpoint = EndPoints.contentShareLink(contentId);

    debugPrint('============ Content Share Link API ============');
    debugPrint('→ method: GET');
    debugPrint('→ endpoint: $endpoint');
    debugPrint('→ material_id: $contentId');

    final response = await apiConsumer.get(endpoint);

    debugPrint('✓ content share link received');
    debugPrint('================================================');

    return ContentShareLinkModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<SharedContentLinkModel> resolveSharedContentLink(String slug) async {
    final endpoint = EndPoints.sharedContentLink(slug);

    debugPrint('============ Resolve Shared Content API ============');
    debugPrint('→ method: GET');
    debugPrint('→ endpoint: $endpoint');
    debugPrint('→ slug: $slug');

    final response = await apiConsumer.get(endpoint);

    debugPrint('✓ shared content resolved');
    debugPrint('====================================================');

    return SharedContentLinkModel.fromJson(response as Map<String, dynamic>);
  }

  //    Download Content
  @override
  Future<String> downloadContent(int contentId) async {
    debugPrint(
      '================ DownloadContentRemoteDataSource ================',
    );
    debugPrint('GET: ${EndPoints.downloadContent(contentId)}');

    final response = await apiConsumer.downloadBytes(
      EndPoints.downloadContent(contentId),
      options: Options(responseType: ResponseType.bytes),
    );

    final bytes = response.data;

    if (bytes == null || bytes.isEmpty) {
      throw Exception('فشل تحميل الملف: الملف فارغ');
    }

    final directory =
        await getDownloadsDirectory() ??
        await getApplicationDocumentsDirectory();

    final fileName = _resolveDownloadedFileName(
      response: response,
      contentId: contentId,
    );

    final file = File('${directory.path}${Platform.pathSeparator}$fileName');

    await file.writeAsBytes(bytes, flush: true);

    debugPrint('Download content saved successfully');
    debugPrint('filePath: ${file.path}');

    return file.path;
  }

  String _resolveDownloadedFileName({
    required Response<List<int>> response,
    required int contentId,
  }) {
    final contentDisposition = response.headers.value('content-disposition');

    if (contentDisposition != null && contentDisposition.isNotEmpty) {
      final utf8Match = RegExp(
        r"filename\*=UTF-8''([^;]+)",
        caseSensitive: false,
      ).firstMatch(contentDisposition);

      if (utf8Match != null) {
        return _sanitizeFileName(
          _decodeFileName(utf8Match.group(1)!),
          contentId: contentId,
        );
      }

      final normalMatch = RegExp(
        r'filename="?([^";]+)"?',
        caseSensitive: false,
      ).firstMatch(contentDisposition);

      if (normalMatch != null) {
        return _sanitizeFileName(normalMatch.group(1)!, contentId: contentId);
      }
    }

    final contentType = response.headers.value('content-type') ?? '';

    final extension = contentType.contains('pdf')
        ? 'pdf'
        : contentType.contains('jpeg')
        ? 'jpg'
        : contentType.contains('png')
        ? 'png'
        : contentType.contains('zip')
        ? 'zip'
        : 'bin';

    return 'library_content_$contentId.$extension';
  }

  String _decodeFileName(String value) {
    try {
      return Uri.decodeComponent(value);
    } on FormatException {
      return value;
    }
  }

  String _sanitizeFileName(String value, {required int contentId}) {
    final fileName = value
        .replaceAll('\\', '/')
        .split('/')
        .last
        .replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '_')
        .trim();

    if (fileName.isEmpty || fileName == '.' || fileName == '..') {
      return 'library_content_$contentId.bin';
    }

    return fileName;
  }
}
