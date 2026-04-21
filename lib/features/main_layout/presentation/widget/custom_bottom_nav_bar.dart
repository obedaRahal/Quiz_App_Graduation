import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/main_layout/presentation/manager/cubit/bottom_nav_cubit.dart';
import 'package:quiz_app_grad/features/main_layout/presentation/manager/cubit/bottom_nav_state.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<BottomNavCubit, BottomNavState>(
      buildWhen: (previous, current) =>
          previous.currentIndex != current.currentIndex,
      builder: (context, state) {
        final items = [
          _NavItemData(image: AppImage.home, label: 'الرئيسية'),
          _NavItemData(image: AppImage.library, label: 'المكتبة'),
          _NavItemData(image: AppImage.chemical, label: 'المختبر'),
          _NavItemData(image: AppImage.bookmark, label: 'الخطة'),
        ];

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: 82,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppPalette.fieldColorNDark : AppPalette.white,

              boxShadow: [
                // BoxShadow(
                //   color: Colors.black.withOpacity(0.08),
                //   blurRadius: 18,
                //   offset: const Offset(0, -4),
                // ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                items.length,
                (index) => _BottomNavItem(
                  data: items[index],
                  isSelected: state.currentIndex == index,
                  onTap: () {
                    context.read<BottomNavCubit>().changeTab(index);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final _NavItemData data;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.all(isSelected ? SizeConfig.w(0.025) : 0),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark
                          ? AppPalette.primaryDark.withOpacity(0.15)
                          : AppPalette.primary.withOpacity(0.12))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
                data.image,
                color: isSelected
                    ? isDark
                          ? AppPalette.primaryDark
                          : AppPalette.primary
                    : isDark
                    ? AppPalette.grey2Dark
                    : AppPalette.greyMedium,
              ),
            ),
            const SizedBox(height: 4),
            CustomTextWidget(
              data.label,
              fontSize: SizeConfig.diagonal * .015,
              color: isSelected
                  ? isDark
                        ? AppPalette.primaryDark
                        : AppPalette.primary
                  : isDark
                  ? AppPalette.grey2Dark
                  : AppPalette.greyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemData {
  final String image;
  final String label;

  _NavItemData({required this.image, required this.label});
}
