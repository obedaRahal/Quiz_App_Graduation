enum StudyTaskRepeatPattern {
  none,
  weekly,
  everyTwoWeeks,
  everyThreeWeeks,
  everyFourWeeks,
}

extension StudyTaskRepeatPatternApiValue on StudyTaskRepeatPattern {
  String get apiValue {
    switch (this) {
      case StudyTaskRepeatPattern.none:
        return 'بدون تكرار';

      case StudyTaskRepeatPattern.weekly:
        return 'كل أسبوع';

      case StudyTaskRepeatPattern.everyTwoWeeks:
        return 'كل أسبوعين';

      case StudyTaskRepeatPattern.everyThreeWeeks:
        return 'كل 3 أسابيع';

      case StudyTaskRepeatPattern.everyFourWeeks:
        return 'كل 4 أسابيع';
    }
  }
}

StudyTaskRepeatPattern studyTaskRepeatPatternFromApi(String value) {
  switch (value.trim()) {
    case 'كل أسبوع':
      return StudyTaskRepeatPattern.weekly;

    case 'كل أسبوعين':
      return StudyTaskRepeatPattern.everyTwoWeeks;

    case 'كل 3 أسابيع':
      return StudyTaskRepeatPattern.everyThreeWeeks;

    case 'كل 4 أسابيع':
      return StudyTaskRepeatPattern.everyFourWeeks;

    case 'بدون تكرار':
    default:
      return StudyTaskRepeatPattern.none;
  }
}
