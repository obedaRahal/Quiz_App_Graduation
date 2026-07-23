import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/search/domain/entities/search_history_entity.dart';
import 'package:quiz_app_grad/features/search/domain/reposirories/search_repository.dart';

class GetSearchHistoryUseCase {
  final SearchRepository repository;

  const GetSearchHistoryUseCase(this.repository);

  Future<Either<Failure, List<SearchHistoryEntity>>> call() {
    debugPrint('============ GetSearchHistoryUseCase.call ============');
    debugPrint('=================================================');

    return repository.getSearchHistory();
  }
}
