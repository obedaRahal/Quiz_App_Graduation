class FilterTestsParams {
  final String scope;

  /// القيم حسب Postman: all - paid
  final String type;

  /// القيم حسب Postman: all - arabic - english - mixed
  final String language;

  /// القيم: 0 - 1
  final int? hasTimer;

  /// القيم: 10 - 20 - 30 - 40 - 50 - 60 - 70 - 80 - 90 - 100
  final int? questionsCountLte;

  /// القيم: 20 - 30 - 40 - 50 - 60 - 70 - 80
  final int? passMarkLte;

  final int? interestId;

  final int? perPage;
  final String? cursor;

  const FilterTestsParams({
    this.scope = 'explore',
    this.type = 'all',
    this.language = 'all',
    this.hasTimer,
    this.questionsCountLte,
    this.passMarkLte,
    this.interestId,
    this.perPage,
    this.cursor,
  });
FilterTestsParams copyWith({
  String? scope,
  String? type,
  String? language,
  Object? hasTimer = _sentinel,
  Object? questionsCountLte = _sentinel,
  Object? passMarkLte = _sentinel,
  Object? interestId = _sentinel,
  Object? perPage = _sentinel,
  Object? cursor = _sentinel,
}) {
  return FilterTestsParams(
    scope: scope ?? this.scope,
    type: type ?? this.type,
    language: language ?? this.language,
    hasTimer: hasTimer == _sentinel ? this.hasTimer : hasTimer as int?,
    questionsCountLte: questionsCountLte == _sentinel
        ? this.questionsCountLte
        : questionsCountLte as int?,
    passMarkLte:
        passMarkLte == _sentinel ? this.passMarkLte : passMarkLte as int?,
    interestId: interestId == _sentinel ? this.interestId : interestId as int?,
    perPage: perPage == _sentinel ? this.perPage : perPage as int?,
    cursor: cursor == _sentinel ? this.cursor : cursor as String?,
  );
}

static const Object _sentinel = Object();
  Map<String, dynamic> toQueryParameters() {
    final query = <String, dynamic>{
      'scope': scope,
      'type': type,
      'language': language,
    };

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

    if (perPage != null) {
      query['per_page'] = perPage;
    }

    if (cursor != null && cursor!.trim().isNotEmpty) {
      query['cursor'] = cursor;
    }

    return query;
  }
}