class FilterMyProfileTestsParams {
  final String scope;

  final String? type;
  final String? status;
  final String? language;
  final int? hasTimer;
  final int? questionsCountLte;
  final int? passMarkLte;
  final int? interestId;
  final String? cursor;

  const FilterMyProfileTestsParams({
    this.scope = 'my_tests',
    this.type,
    this.status,
    this.language,
    this.hasTimer,
    this.questionsCountLte,
    this.passMarkLte,
    this.interestId,
    this.cursor,
  });

  bool get hasAnyFilter =>
      type != null ||
      status != null ||
      language != null ||
      hasTimer != null ||
      questionsCountLte != null ||
      passMarkLte != null ||
      interestId != null;

  Map<String, dynamic> toQueryParameters() {
    final query = <String, dynamic>{
      'scope': scope,
    };

    if (type != null && type!.trim().isNotEmpty) {
      query['type'] = type!.trim();
    }

    if (status != null && status!.trim().isNotEmpty) {
      query['status'] = status!.trim();
    }

    if (language != null && language!.trim().isNotEmpty) {
      query['language'] = language!.trim();
    }

    if (hasTimer != null) {
      query['has_timer'] = hasTimer;
    }

    if (questionsCountLte != null) {
      query['questions_count_lte'] = questionsCountLte;
    }

    if (passMarkLte != null) {
      query['pass_mark_lte'] = passMarkLte;
    }

    if (interestId != null) {
      query['interest_id'] = interestId;
    }

    if (cursor != null && cursor!.trim().isNotEmpty) {
      query['cursor'] = cursor!.trim();
    }

    return query;
  }

  FilterMyProfileTestsParams copyWith({
    String? scope,
    String? type,
    String? status,
    String? language,
    int? hasTimer,
    int? questionsCountLte,
    int? passMarkLte,
    int? interestId,
    String? cursor,
  }) {
    return FilterMyProfileTestsParams(
      scope: scope ?? this.scope,
      type: type ?? this.type,
      status: status ?? this.status,
      language: language ?? this.language,
      hasTimer: hasTimer ?? this.hasTimer,
      questionsCountLte:
          questionsCountLte ?? this.questionsCountLte,
      passMarkLte: passMarkLte ?? this.passMarkLte,
      interestId: interestId ?? this.interestId,
      cursor: cursor ?? this.cursor,
    );
  }
}