import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/scientific_classification_entity.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_cubit.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_state.dart'
    show CreateTestState;

class CreateTestScientificClassificationSection extends StatelessWidget {
  const CreateTestScientificClassificationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<CreateTestCubit, CreateTestState>(
      buildWhen: (previous, current) {
        return previous.selectedScientificCategories !=
                current.selectedScientificCategories ||
            previous.selectedScientificInterestIds !=
                current.selectedScientificInterestIds;
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ScientificHeader(),

            SizedBox(height: SizeConfig.h(0.014)),

            if (state.selectedScientificCategories.isNotEmpty) ...[
              Wrap(
                spacing: SizeConfig.w(0.018),
                runSpacing: SizeConfig.h(0.008),
                alignment: WrapAlignment.end,
                children: [
                  ...state.selectedScientificCategories.map(
                    (category) => _CategoryChip(title: category),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.h(0.012)),
            ],

            InkWell(
              onTap: () {
                final cubit = context.read<CreateTestCubit>();

                cubit.prepareScientificCategoriesPicker();
                cubit.fetchScientificClassifications();

                showScientificClassificationPicker(context);
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: SizeConfig.h(0.03),
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.025)),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppPalette.greyMediumDark
                      : AppPalette.whiteToGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextWidget(
                      'اختر تصنيفا علميا',
                      fontSize: SizeConfig.text(0.024),
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppPalette.titleWhiteINDark
                          : AppPalette.greyMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: SizeConfig.w(0.006)),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: SizeConfig.text(0.038),
                      color: isDark
                          ? AppPalette.titleWhiteINDark
                          : AppPalette.greyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ScientificHeader extends StatelessWidget {
  const _ScientificHeader();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomAppImage(
              path: AppImage.layers,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
            ),
            SizedBox(width: SizeConfig.w(0.018)),
            CustomTextWidget(
              'التصنيف العلمي',
              fontSize: SizeConfig.text(0.043),
              fontWeight: FontWeight.w900,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
              textAlign: TextAlign.right,
            ),
          ],
        ),
        SizedBox(height: SizeConfig.h(0.006)),
        CustomTextWidget(
          'حدد الموضوع الذي يتعلق هذا الاختبار فيه يمكنك تحديد ثلاث مواضيع على الأكثر',
          fontSize: SizeConfig.text(0.033),
          fontWeight: FontWeight.w500,
          color: AppPalette.greyMedium,
          textAlign: TextAlign.right,
          maxLines: 2,
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String title;

  const _CategoryChip({required this.title});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: SizeConfig.h(0.028),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.025)),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.greyLightDark : AppPalette.primarySoft,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextWidget(
            '#',
            fontSize: SizeConfig.text(0.03),
            fontWeight: FontWeight.w900,
            color: appColors.primaryToPrimaryDark,
            textAlign: TextAlign.center,
          ),
          SizedBox(width: SizeConfig.w(0.006)),
          CustomTextWidget(
            title,
            fontSize: SizeConfig.text(0.026),
            fontWeight: FontWeight.w800,
            color: appColors.primaryToPrimaryDark,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

Future<void> showScientificClassificationPicker(BuildContext context) {
  final cubit = context.read<CreateTestCubit>();
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'scientific_classification_picker',
    barrierColor: Colors.black.withOpacity(0.18),
    transitionDuration: const Duration(milliseconds: 240),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return BlocProvider.value(
        value: cubit,
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.5, sigmaY: 4.5),
                child: const SizedBox.expand(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Colors.transparent,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(maxHeight: SizeConfig.h(0.78)),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppPalette.fieldColorNDark
                          : AppPalette.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: const _ScientificClassificationPickerContent(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: FadeTransition(opacity: curvedAnimation, child: child),
      );
    },
  );
}

class _ScientificClassificationPickerContent extends StatelessWidget {
  const _ScientificClassificationPickerContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTestCubit, CreateTestState>(
      buildWhen: (previous, current) {
        return previous.pendingScientificInterestIds !=
                current.pendingScientificInterestIds ||
            previous.isScientificClassificationsLoading !=
                current.isScientificClassificationsLoading ||
            previous.scientificClassificationsError !=
                current.scientificClassificationsError ||
            previous.scientificClassificationGroups !=
                current.scientificClassificationGroups;
      },
      builder: (context, state) {
        final selectedCount = state.pendingScientificInterestIds.length;
        final canSave = selectedCount > 0;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final appColors = context.appColors;
        return Column(
          children: [
            SizedBox(height: SizeConfig.h(0.010)),

            Container(
              width: SizeConfig.w(0.13),
              height: SizeConfig.h(0.0045),
              decoration: BoxDecoration(
                color: isDark
                    ? AppPalette.titleWhiteINDark
                    : AppPalette.smallContainerGrey,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            SizedBox(height: SizeConfig.h(0.008)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.04)),
              child: SizedBox(
                height: SizeConfig.h(0.046),
                width: double.infinity,
                child: Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    SizedBox(
                      width: SizeConfig.w(0.16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: SizeConfig.h(0.024),
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.w(0.01),
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppPalette.fieldColorNDark
                                : AppPalette.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? AppPalette.borderFieldColorNDark
                                  : AppPalette.borderFieldColorNLight,
                            ),
                          ),
                          child: Center(
                            child: CustomTextWidget(
                              '$selectedCount/${CreateTestCubit.maxScientificCategoriesCount}',
                              fontSize: SizeConfig.text(0.030),
                              fontWeight: FontWeight.w600,
                              color: appColors.primaryToPrimaryDark,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Center(
                        child: CustomTextWidget(
                          'التصنيف العلمي',
                          fontSize: SizeConfig.text(0.048),
                          fontWeight: FontWeight.w900,
                          color: isDark
                              ? AppPalette.textWhiteINDark
                              : AppPalette.textColorInHome,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    SizedBox(width: SizeConfig.w(0.16)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: const _DashedDivider(),
            ),

            Expanded(child: _ScientificPickerBody(state: state)),

            Container(
              padding: EdgeInsets.only(
                left: SizeConfig.w(0.04),
                right: SizeConfig.w(0.04),
                top: SizeConfig.h(0.010),
                bottom: SizeConfig.h(0.014),
              ),
              decoration: BoxDecoration(
                color: isDark ? AppPalette.fieldColorNDark : AppPalette.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: SizeConfig.h(0.048),
                child: ElevatedButton(
                  onPressed: canSave
                      ? () {
                          context
                              .read<CreateTestCubit>()
                              .confirmScientificCategories();

                          Navigator.of(context).pop();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColors.primaryToPrimaryDark,
                    disabledBackgroundColor: isDark
                        ? AppPalette.borderFieldColorNDark
                        : AppPalette.white,
                    foregroundColor: isDark
                        ? AppPalette.borderFieldColorNDark
                        : AppPalette.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: CustomTextWidget(
                    'حفظ',
                    fontSize: SizeConfig.text(0.040),
                    fontWeight: FontWeight.bold,
                    color: canSave
                        ? isDark
                              ? AppPalette.black
                              : AppPalette.white
                        : AppPalette.greyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ScientificPickerBody extends StatelessWidget {
  final CreateTestState state;

  const _ScientificPickerBody({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isScientificClassificationsLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (state.scientificClassificationsError != null) {
      return _ScientificPickerError(
        message: state.scientificClassificationsError!,
      );
    }

    if (state.scientificClassificationGroups.isEmpty) {
      return const _ScientificPickerEmpty();
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.035),
        vertical: SizeConfig.h(0.014),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: state.scientificClassificationGroups
            .map(
              (group) => _ScientificCategoryGroup(
                group: group,
                selectedInterestIds: state.pendingScientificInterestIds,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ScientificPickerError extends StatelessWidget {
  final String message;

  const _ScientificPickerError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.06)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: SizeConfig.text(0.080),
              color: const Color(0xFFE85050),
            ),
            SizedBox(height: SizeConfig.h(0.010)),
            CustomTextWidget(
              'تعذر جلب التصنيفات العلمية',
              fontSize: SizeConfig.text(0.030),
              fontWeight: FontWeight.w900,
              color: AppPalette.textColorInHome,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.h(0.006)),
            CustomTextWidget(
              message,
              fontSize: SizeConfig.text(0.024),
              fontWeight: FontWeight.w600,
              color: AppPalette.greyMedium,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            SizedBox(height: SizeConfig.h(0.014)),
            InkWell(
              onTap: () {
                context.read<CreateTestCubit>().fetchScientificClassifications(
                  forceRefresh: true,
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: SizeConfig.h(0.040),
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.06)),
                decoration: BoxDecoration(
                  color: const Color(0xFF5B86FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomTextWidget(
                    'إعادة المحاولة',
                    fontSize: SizeConfig.text(0.027),
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScientificPickerEmpty extends StatelessWidget {
  const _ScientificPickerEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomTextWidget(
        'لا توجد تصنيفات علمية حالياً',
        fontSize: SizeConfig.text(0.030),
        fontWeight: FontWeight.w800,
        color: AppPalette.greyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ScientificCategoryGroup extends StatelessWidget {
  final ScientificClassificationGroupEntity group;
  final List<int> selectedInterestIds;

  const _ScientificCategoryGroup({
    required this.group,
    required this.selectedInterestIds,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (group.interests.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: SizeConfig.h(0.018),
        right: SizeConfig.w(0.02),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            group.title,
            fontSize: SizeConfig.text(0.044),
            fontWeight: FontWeight.w900,
            color: isDark
                ? AppPalette.textWhiteINDark
                : AppPalette.textColorInHome,
            textAlign: TextAlign.right,
          ),

          SizedBox(height: SizeConfig.h(0.010)),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: group.interests.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: SizeConfig.h(0.010),
              crossAxisSpacing: SizeConfig.w(0.025),
              childAspectRatio: 3.2,
            ),
            itemBuilder: (context, index) {
              final interest = group.interests[index];
              final isSelected = selectedInterestIds.contains(interest.id);

              return _ScientificCategoryTile(
                interest: interest,
                isSelected: isSelected,
                isMaxReached:
                    selectedInterestIds.length >=
                    CreateTestCubit.maxScientificCategoriesCount,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ScientificCategoryTile extends StatelessWidget {
  final ScientificInterestEntity interest;
  final bool isSelected;
  final bool isMaxReached;

  const _ScientificCategoryTile({
    required this.interest,
    required this.isSelected,
    required this.isMaxReached,
  });

  @override
  Widget build(BuildContext context) {
    final canTap = isSelected || !isMaxReached;
    final appColors = context.appColors;
    final iconColor = _parseHexColor(interest.iconColor);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: canTap
          ? () {
              context.read<CreateTestCubit>().togglePendingScientificInterest(
                interest.id,
              );
            }
          : null,
      borderRadius: BorderRadius.circular(8),
      child: Opacity(
        opacity: canTap ? 1 : 0.55,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 170),
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.024)),
          decoration: BoxDecoration(
            color: isSelected
                ? appColors.primaryToPrimaryDark
                : isDark
                ? AppPalette.borderFieldColorNDark
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? appColors.primaryToPrimaryDark
                  : isDark
                  ? AppPalette.greyLightDark
                  : AppPalette.borderFieldColorNLight,
              width: isSelected ? 1.2 : 1.1,
            ),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              CustomAppImage(
                path: interest.iconSvg,
                width: SizeConfig.w(0.056),
                height: SizeConfig.w(0.056),
                color: isSelected
                    ? isDark
                          ? AppPalette.black
                          : Colors.white
                    : iconColor,
                fallbackIcon: Icons.category_outlined,
                fallbackIconColor: isSelected
                    ? isDark
                          ? AppPalette.black
                          : Colors.white
                    : iconColor,
                fallbackBackgroundColor: Colors.transparent,
                showLoadingForSvg: false,
                showLoadingForNetwork: false,
              ),

              SizedBox(width: SizeConfig.w(0.018)),

              Expanded(
                child: CustomTextWidget(
                  interest.name,
                  fontSize: SizeConfig.text(0.034),
                  fontWeight: FontWeight.w800,
                  color: isSelected
                      ? isDark
                            ? AppPalette.black
                            : Colors.white
                      : isDark
                      ? AppPalette.textWhiteINDark
                      : AppPalette.greyMedium,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _parseHexColor(String value, {Color fallback = const Color(0xFF5583FF)}) {
  final hex = value.replaceAll('#', '').trim();

  if (hex.length != 6 && hex.length != 8) {
    return fallback;
  }

  final normalized = hex.length == 6 ? 'FF$hex' : hex;
  final colorValue = int.tryParse(normalized, radix: 16);

  if (colorValue == null) {
    return fallback;
  }

  return Color(colorValue);
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      width: double.infinity,
      child: CustomPaint(painter: _DashedLinePainter()),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppPalette.greyMedium
      ..strokeWidth = 1.2;

    double x = 0;

    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + 9, 0), paint);
      x += 15;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
