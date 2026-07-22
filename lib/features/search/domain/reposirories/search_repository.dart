import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/search/domain/entities/search_user_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, SearchUsersResponseEntity>> searchUsers({
    required String query,
    String? cursor,
  });
}
