import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import '../models/all_interests_response_model.dart';

abstract class AllInterestsRemoteDataSource {
  Future<AllInterestsResponseModel> getAllInterests();
}

class AllInterestsRemoteDataSourceImpl implements AllInterestsRemoteDataSource {
  final ApiConsumer api;

  const AllInterestsRemoteDataSourceImpl({
    required this.api,
  });

  @override
  Future<AllInterestsResponseModel> getAllInterests() async {
    final response = await api.get(
      EndPoints.allInterests,
    );

    return AllInterestsResponseModel.fromJson(response);
  }
}