class GetStudyPlanDailyOverviewParams {
  final String date;
  final String rangeStart;
  final String rangeEnd;

  const GetStudyPlanDailyOverviewParams({
    required this.date,
    required this.rangeStart,
    required this.rangeEnd,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      'date': date,
      'range_start': rangeStart,
      'range_end': rangeEnd,
    };
  }

  GetStudyPlanDailyOverviewParams copyWith({
    String? date,
    String? rangeStart,
    String? rangeEnd,
  }) {
    return GetStudyPlanDailyOverviewParams(
      date: date ?? this.date,
      rangeStart: rangeStart ?? this.rangeStart,
      rangeEnd: rangeEnd ?? this.rangeEnd,
    );
  }

  @override
  String toString() {
    return 'GetStudyPlanDailyOverviewParams('
        'date: $date, '
        'rangeStart: $rangeStart, '
        'rangeEnd: $rangeEnd'
        ')';
  }
}