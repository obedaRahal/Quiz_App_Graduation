import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_state.dart';

class ProfileTabItem<T> {
  final String title;
  final T tab;

  const ProfileTabItem({required this.title, required this.tab});
}

class ProfileTabsSection<T> extends StatelessWidget {
  final T selectedTab;
  final List<ProfileTabItem<T>> tabs;
  final ValueChanged<T> onTabSelected;

  const ProfileTabsSection({
    super.key,
    required this.selectedTab,
    required this.tabs,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomDivider(height: 3, thickness: 3),
          ),

          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: tabs.map((item) {
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
                        width: isSelected
                            ? (selectedTab == MyProfileTab.personalInfo
                                  ? SizeConfig.w(0.22)
                                  : SizeConfig.w(0.13))
                            : 0,
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
      ),
    );
  }
}
