import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/empty_action_box.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plans_params.dart';

class ManagedStudyPlansEmptyState extends StatelessWidget {
  final StudyPlansTab selectedTab;
  final bool isSearchEmptyResult;

  const ManagedStudyPlansEmptyState({
    super.key,
    required this.selectedTab,
    this.isSearchEmptyResult = false,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyActionBox(
      icon: isSearchEmptyResult
          ? Icons.search_off_rounded
          : Icons.event_note_rounded,
      title: isSearchEmptyResult ? 'لا توجد نتائج' : _emptyTitle(),
      description: isSearchEmptyResult
          ? 'جرّب البحث باستخدام عنوان مختلف'
          : _emptyDescription(),
    );
  }

  String _emptyTitle() {
    switch (selectedTab) {
      case StudyPlansTab.current:
        return 'لا توجد خطط حالية';

      case StudyPlansTab.expired:
        return 'لا توجد خطط منتهية';

      case StudyPlansTab.future:
        return 'لا توجد خطط مستقبلية';
    }
  }

  String _emptyDescription() {
    switch (selectedTab) {
      case StudyPlansTab.current:
        return 'لا توجد لديك خطة دراسية تعمل عليها حاليًا';

      case StudyPlansTab.expired:
        return 'لم تنتهِ أي خطة دراسية بعد';

      case StudyPlansTab.future:
        return 'لا توجد لديك خطة تبدأ في وقت لاحق';
    }
  }
}

class EmptyStateCardPlanAndTask extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const EmptyStateCardPlanAndTask({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.inbox_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyActionBox(icon: icon, title: title, description: description);
  }
}
