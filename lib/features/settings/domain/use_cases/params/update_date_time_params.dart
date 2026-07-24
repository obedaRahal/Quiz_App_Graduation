class UpdateDateTimeParams {
  final String weekStartsOn;
  final String timeFormat;

  const UpdateDateTimeParams({
    required this.weekStartsOn,
    required this.timeFormat,
  });

  Map<String, dynamic> toJson() {
    return {'week_starts_on': weekStartsOn, 'time_format': timeFormat};
  }
}
