import 'package:quiz_app_grad/features/laboratory/domain/entities/test_by_interest_response_entity.dart';

class SearchTestsByInterestResponseEntity {
  final bool success;
  final String message;
  final List<TestByInterestEntity> tests;
  final SearchTestsByInterestMetaEntity meta;
  final int statusCode;

  const SearchTestsByInterestResponseEntity({
    required this.success,
    required this.message,
    required this.tests,
    required this.meta,
    required this.statusCode,
  });
}

class SearchTestsByInterestMetaEntity {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMorePages;

  const SearchTestsByInterestMetaEntity({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMorePages,
  });
}