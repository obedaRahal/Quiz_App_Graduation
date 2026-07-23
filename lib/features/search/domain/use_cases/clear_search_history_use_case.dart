import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/search/domain/reposirories/search_repository.dart';

class ClearSearchHistoryUseCase {
  final SearchRepository repository;

  const ClearSearchHistoryUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    debugPrint('============ ClearSearchHistoryUseCase.call ============');
    debugPrint('=================================================');

    return repository.clearSearchHistory();
  }
}
