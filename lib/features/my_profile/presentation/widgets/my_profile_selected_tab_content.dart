import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_entity.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_state.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/personal_info_tab/my_profile_personal_info_tab.dart';

class MyProfileSelectedTabContent extends StatelessWidget {
  final MyProfileTab selectedTab;
  final MyProfileEntity profile;

  const MyProfileSelectedTabContent({
    super.key,
    required this.selectedTab,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedTab) {
      case MyProfileTab.personalInfo:
        return MyProfilePersonalInfoTab(profile: profile);

      case MyProfileTab.tests:
        return const _ComingSoonTab(title: 'اختباراتك ستظهر هنا');

      case MyProfileTab.folders:
        return const _ComingSoonTab(title: 'قوائمك ستظهر هنا');

      case MyProfileTab.content:
        return const _ComingSoonTab(title: 'محتواك سيظهر هنا');

      case MyProfileTab.achievements:
        return const _ComingSoonTab(title: 'إنجازاتك ستظهر هنا');
    }
  }
}

class _ComingSoonTab extends StatelessWidget {
  final String title;

  const _ComingSoonTab({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomTextWidget(
        title,
        color: AppPalette.greyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}