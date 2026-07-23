import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/search/domain/reposirories/search_repository.dart';
import 'package:quiz_app_grad/features/search/domain/use_cases/params/delete_search_history_item_params.dart';

class DeleteSearchHistoryItemUseCase {
  final SearchRepository repository;

  const DeleteSearchHistoryItemUseCase(this.repository);

  Future<Either<Failure, void>> call(DeleteSearchHistoryItemParams params) {
    debugPrint('============ DeleteSearchHistoryItemUseCase.call ============');
    debugPrint('→ ID: ${params.historyId}');
    debugPrint('=================================================');

    return repository.deleteSearchHistoryItem(historyId: params.historyId);
  }
}
