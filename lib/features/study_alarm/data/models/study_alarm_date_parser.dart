DateTime parseStudyAlarmDateTime(String value) {
  final normalizedValue = value.trim().replaceFirst(' ', 'T');

  return DateTime.parse(normalizedValue);
}
