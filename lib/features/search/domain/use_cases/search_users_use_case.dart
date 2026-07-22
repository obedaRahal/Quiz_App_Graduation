import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/search/domain/entities/search_user_entity.dart';
import 'package:quiz_app_grad/features/search/domain/reposirories/search_repository.dart';
import 'package:quiz_app_grad/features/search/domain/use_cases/params/search_users_params.dart';

class SearchUsersUseCase {
  final SearchRepository repository;

  const SearchUsersUseCase(this.repository);

  Future<Either<Failure, SearchUsersResponseEntity>> call(
    SearchUsersParams params,
  ) {
    debugPrint('============ SearchUsersUseCase.call ============');
    debugPrint('→ query: ${params.query}');
    debugPrint('→ cursor: ${params.cursor}');
    debugPrint('=================================================');

    return repository.searchUsers(query: params.query, cursor: params.cursor);
  }
}
