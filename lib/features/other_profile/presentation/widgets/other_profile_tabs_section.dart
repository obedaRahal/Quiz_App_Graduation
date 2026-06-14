import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';

class OtherProfileTabsSection extends StatelessWidget {
  final OtherProfileTab selectedTab;
  final ValueChanged<OtherProfileTab> onTabSelected;

  const OtherProfileTabsSection({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  static const tabs = [
    _OtherProfileTabItem(
      title: 'نظرة عامة',
      tab: OtherProfileTab.overview,
    ),
    _OtherProfileTabItem(
      title: 'الاختبارات',
      tab: OtherProfileTab.tests,
    ),
    _OtherProfileTabItem(
      title: 'المجلدات',
      tab: OtherProfileTab.folder,
    ),
    _OtherProfileTabItem(
      title: 'المحتوى',
      tab: OtherProfileTab.content,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: _OtherProfileTabsHeader(
        selectedTab: selectedTab,
        onTabSelected: onTabSelected,
      ),
    );
  }
}

class _OtherProfileTabItem {
  final String title;
  final OtherProfileTab tab;

  const _OtherProfileTabItem({
    required this.title,
    required this.tab,
  });
}

class _OtherProfileTabsHeader extends StatelessWidget {
  final OtherProfileTab selectedTab;
  final ValueChanged<OtherProfileTab> onTabSelected;

  const _OtherProfileTabsHeader({
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: CustomDivider(
            height: 3,
            thickness: 3,
          ),
        ),

        Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: OtherProfileTabsSection.tabs.map((item) {
              final isSelected = selectedTab == item.tab;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTabSelected(item.tab),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextWidget(
                      item.title,
                      color: isSelected
                          ? appColors.blackToGrey2Dark
                          : AppPalette.greyMedium,
                      fontFamily: isSelected
                          ? AppFont.elMessiriSemiBold
                          : AppFont.elMessiriRegular,
                      fontSize: SizeConfig.text(0.03),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: SizeConfig.h(0.006)),

                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      height: 3.5,
                      width: isSelected ? SizeConfig.w(0.13) : 0,
                      decoration: BoxDecoration(
                        color: appColors.primaryToPrimaryDark,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}