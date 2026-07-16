import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/filter_my_profile_tests_params.dart';

class MyProfileTestsFilterResult {
  final String? type;
  final String? status;
  final String? language;

  final int? hasTimer;
  final int? questionsCountLte;
  final int? passMarkLte;
  final int? interestId;

  const MyProfileTestsFilterResult({
    this.type,
    this.status,
    this.language,
    this.hasTimer,
    this.questionsCountLte,
    this.passMarkLte,
    this.interestId,
  });

  bool get hasAnyFilter =>
      type != null ||
      status != null ||
      language != null ||
      hasTimer != null ||
      questionsCountLte != null ||
      passMarkLte != null ||
      interestId != null;

  FilterMyProfileTestsParams toParams() {
    return FilterMyProfileTestsParams(
      type: type,
      status: status,
      language: language,
      hasTimer: hasTimer,
      questionsCountLte: questionsCountLte,
      passMarkLte: passMarkLte,
      interestId: interestId,
    );
  }
}