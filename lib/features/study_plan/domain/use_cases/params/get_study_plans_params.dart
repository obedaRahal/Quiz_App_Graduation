enum StudyPlansTab { current, expired, future }

extension StudyPlansTabX on StudyPlansTab {
  String get apiValue {
    switch (this) {
      case StudyPlansTab.current:
        return 'current';

      case StudyPlansTab.expired:
        return 'expired';

      case StudyPlansTab.future:
        return 'future';
    }
  }

  String get title {
    switch (this) {
      case StudyPlansTab.current:
        return 'حالية';

      case StudyPlansTab.expired:
        return 'منتهية';

      case StudyPlansTab.future:
        return 'مستقبلية';
    }
  }
}

class GetStudyPlansParams {
  final StudyPlansTab tab;

  const GetStudyPlansParams({required this.tab});

  Map<String, dynamic> toQueryParameters() {
    return {'tab': tab.apiValue};
  }

  @override
  String toString() {
    return 'GetStudyPlansParams('
        'tab: ${tab.apiValue}'
        ')';
  }
}
