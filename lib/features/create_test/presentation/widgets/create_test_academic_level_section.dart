import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_cubit.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_state.dart';

class CreateTestAcademicLevelSection extends StatelessWidget {
  const CreateTestAcademicLevelSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;
    return BlocBuilder<CreateTestCubit, CreateTestState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AcademicHeader(),

            SizedBox(height: SizeConfig.h(0.014)),

            if (state.selectedAcademicLevel.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.026)),
                height: SizeConfig.h(0.028),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppPalette.greyLightDark
                      : AppPalette.primarySoft,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextWidget(
                      '#',
                      fontSize: SizeConfig.text(0.028),
                      fontWeight: FontWeight.w900,
                      color: appColors.primaryToPrimaryDark,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: SizeConfig.w(0.006)),
                    CustomTextWidget(
                      state.selectedAcademicLevel,
                      fontSize: SizeConfig.text(0.022),
                      fontWeight: FontWeight.w800,
                      color: appColors.primaryToPrimaryDark,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

            SizedBox(height: SizeConfig.h(0.008)),

            InkWell(
              onTap: () {
                showAcademicLevelPicker(context);
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
                      'اختر المستوى الدراسي',
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

class _AcademicHeader extends StatelessWidget {
  const _AcademicHeader();
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
              path: AppImage.academic,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
            ),
            SizedBox(width: SizeConfig.w(0.018)),
            CustomTextWidget(
              'المستوى الدراسي',
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
          'حدد المستوى التعليمي الذي يناسب محتوى هذا الاختبار',
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

// Future<void> showAcademicLevelPicker(BuildContext context) {
//   final cubit = context.read<CreateTestCubit>();
//   final Map<String, List<String>> levelsMap = {
//     'جامعة': [
//       'سنة أولى جامعة',
//       'سنة ثانية جامعة',
//       'سنة ثالثة جامعة',
//       'سنة رابعة جامعة',
//       'سنة خامسة جامعة',
//       'سنة سادسة جامعة',
//     ],
//     'مدرسة': ['صف أول', 'صف ثاني', 'صف ثالث', 'صف رابع', 'صف خامس', 'صف سادس'],
//     'إعدادي': ['صف سابع', 'صف ثامن', 'صف تاسع'],
//     'ثانوي': [
//       'صف عاشر',
//       'صف حادي عشر',
//       'صف ثاني عشر',
//       'أدبي',
//       'علمي',
//       'مهني',
//       'بكالوريا',
//     ],
//     'معهد': ['سنة أولى معهد', 'سنة ثانية معهد', 'سنة ثالثة معهد'],
//     'أخرى': ['ماجستير', 'دكتوراه', 'معلومات عامة'],
//   };

//   return showGeneralDialog<void>(
//     context: context,
//     barrierDismissible: true,
//     barrierLabel: 'academic_level_picker',
//     barrierColor: Colors.black.withOpacity(0.18),
//     transitionDuration: const Duration(milliseconds: 240),
//     pageBuilder: (dialogContext, animation, secondaryAnimation) {
//       return BlocProvider.value(
//         value: cubit,
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 4.5, sigmaY: 4.5),
//                 child: const SizedBox.expand(),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Material(
//                 color: Colors.transparent,
//                 child: Container(
//                   width: double.infinity,
//                   constraints: BoxConstraints(maxHeight: SizeConfig.h(0.86)),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(24),
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       SizedBox(height: SizeConfig.h(0.010)),
//                       Container(
//                         width: SizeConfig.w(0.13),
//                         height: SizeConfig.h(0.0045),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFC8C8C8),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       SizedBox(height: SizeConfig.h(0.008)),
//                       CustomTextWidget(
//                         'المستوى الدراسي',
//                         fontSize: SizeConfig.text(0.040),
//                         fontWeight: FontWeight.w900,
//                         color: AppPalette.textColorInHome,
//                         textAlign: TextAlign.right,
//                       ),
//                       SizedBox(height: SizeConfig.h(0.012)),
//                       Expanded(
//                         child: SingleChildScrollView(
//                           physics: const BouncingScrollPhysics(),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: SizeConfig.w(0.035),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: levelsMap.entries.map((entry) {
//                               final category = entry.key;
//                               final options = entry.value;
//                               return Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   CustomTextWidget(
//                                     category,
//                                     fontSize: SizeConfig.text(0.033),
//                                     fontWeight: FontWeight.w900,
//                                     color: AppPalette.textColorInHome,
//                                     textAlign: TextAlign.right,
//                                   ),
//                                   SizedBox(height: SizeConfig.h(0.010)),
//                                   Wrap(
//                                     spacing: SizeConfig.w(0.018),
//                                     runSpacing: SizeConfig.h(0.008),
//                                     children: options.map((option) {
//                                       final isSelected =
//                                           cubit.state.selectedAcademicLevel ==
//                                           option;
//                                       return _AcademicLevelTile(
//                                         level: option,
//                                         selected: isSelected,
//                                         onTap: () {
//                                           cubit.changeAcademicLevel(option);
//                                           Navigator.of(dialogContext).pop();
//                                         },
//                                       );
//                                     }).toList(),
//                                   ),
//                                   SizedBox(height: SizeConfig.h(0.012)),
//                                 ],
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//     transitionBuilder: (context, animation, secondaryAnimation, child) {
//       final curvedAnimation = CurvedAnimation(
//         parent: animation,
//         curve: Curves.easeOutCubic,
//       );
//       return SlideTransition(
//         position: Tween<Offset>(
//           begin: const Offset(0, 1),
//           end: Offset.zero,
//         ).animate(curvedAnimation),
//         child: FadeTransition(opacity: curvedAnimation, child: child),
//       );
//     },
//   );
// }

// class _AcademicLevelTile extends StatelessWidget {
//   final String level;
//   final bool selected;
//   final VoidCallback onTap;

//   const _AcademicLevelTile({
//     required this.level,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(6),
//       child: Container(
//         height: SizeConfig.h(0.042),
//         padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.030)),
//         margin: EdgeInsets.symmetric(vertical: SizeConfig.h(0.004)),
//         decoration: BoxDecoration(
//           color: selected ? const Color(0xFF5B86FF) : Colors.white,
//           borderRadius: BorderRadius.circular(6),
//           border: Border.all(
//             color: selected ? const Color(0xFF5B86FF) : const Color(0xFFE6E6E6),
//           ),
//         ),
//         child: Row(
//           children: [
//             CustomTextWidget(
//               level,
//               fontSize: SizeConfig.text(0.024),
//               fontWeight: FontWeight.w800,
//               color: selected ? Colors.white : const Color(0xFF8B8B8B),
//               textAlign: TextAlign.right,
//             ),
//             const Spacer(),
//             if (selected)
//               Icon(
//                 Icons.check_circle_rounded,
//                 color: Colors.white,
//                 size: SizeConfig.text(0.033),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
Future<void> showAcademicLevelPicker(BuildContext context) {
  final cubit = context.read<CreateTestCubit>();
  String tempSelectedLevel = cubit.state.selectedAcademicLevel;

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'academic_level_picker',
    barrierColor: Colors.black.withOpacity(0.18),
    transitionDuration: const Duration(milliseconds: 240),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final appColors = context.appColors;

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
                    constraints: BoxConstraints(maxHeight: SizeConfig.h(0.88)),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppPalette.fieldColorNDark
                          : AppPalette.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: StatefulBuilder(
                      builder: (context, setModalState) {
                        return Column(
                          children: [
                            SizedBox(height: SizeConfig.h(0.010)),

                            Container(
                              width: SizeConfig.w(0.13),
                              height: SizeConfig.h(0.0045),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC8C8C8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),

                            SizedBox(height: SizeConfig.h(0.010)),

                            SizedBox(
                              height: SizeConfig.h(0.046),
                              width: double.infinity,
                              child: Center(
                                child: CustomTextWidget(
                                  'المستوى الدراسي',
                                  fontSize: SizeConfig.text(0.048),
                                  fontWeight: FontWeight.w900,
                                  color: isDark
                                      ? AppPalette.textWhiteINDark
                                      : AppPalette.textColorInHome,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: const _AcademicDashedDivider(),
                            ),

                            Expanded(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.w(0.035),
                                  vertical: SizeConfig.h(0.014),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    _AcademicGroupHeader(
                                      title: 'جامعة',
                                      icon: AppImage.academic,
                                    ),

                                    SizedBox(height: SizeConfig.h(0.010)),

                                    _AcademicOptionsGrid(
                                      options: const [
                                        'سنة اولى جامعة',
                                        'سنة ثانية جامعة',
                                        'سنة ثالثة جامعة',
                                        'سنة رابعة جامعة',
                                        'سنة خامسة جامعة',
                                        'سنة سادسة جامعة',
                                      ],
                                      selectedLevel: tempSelectedLevel,
                                      onSelected: (value) {
                                        setModalState(() {
                                          tempSelectedLevel = value;
                                        });
                                      },
                                    ),

                                    SizedBox(height: SizeConfig.h(0.020)),

                                    _AcademicGroupHeader(
                                      title: 'مدرسة',
                                      icon: AppImage.school,
                                    ),

                                    SizedBox(height: SizeConfig.h(0.012)),

                                    const _AcademicStageTitle(title: 'إبتدائي'),

                                    SizedBox(height: SizeConfig.h(0.008)),

                                    _AcademicOptionsGrid(
                                      options: const [
                                        'الصف الأول',
                                        'الصف الثاني',
                                        'الصف الثالث',
                                        'الصف الرابع',
                                        'الصف الخامس',
                                        'الصف السادس',
                                      ],
                                      selectedLevel: tempSelectedLevel,
                                      onSelected: (value) {
                                        setModalState(() {
                                          tempSelectedLevel = value;
                                        });
                                      },
                                    ),

                                    SizedBox(height: SizeConfig.h(0.014)),

                                    const _AcademicStageTitle(title: 'إعدادي'),

                                    SizedBox(height: SizeConfig.h(0.008)),

                                    _AcademicOptionsGrid(
                                      options: const [
                                        'الصف السابع',
                                        'الصف الثامن',
                                        'الصف التاسع',
                                      ],
                                      selectedLevel: tempSelectedLevel,
                                      onSelected: (value) {
                                        setModalState(() {
                                          tempSelectedLevel = value;
                                        });
                                      },
                                    ),

                                    SizedBox(height: SizeConfig.h(0.014)),

                                    const _AcademicStageTitle(title: 'ثانوي'),

                                    SizedBox(height: SizeConfig.h(0.008)),

                                    _AcademicOptionsGrid(
                                      options: const [
                                        'الصف العاشر',
                                        'الصف الحادي عشر',
                                        'البكلوريا',
                                      ],
                                      selectedLevel: tempSelectedLevel,
                                      onSelected: (value) {
                                        setModalState(() {
                                          tempSelectedLevel = value;
                                        });
                                      },
                                    ),

                                    //SizedBox(height: SizeConfig.h(0.008)),

                                    // _SecondaryTracksRow(
                                    //   selectedLevel: tempSelectedLevel,
                                    //   onSelected: (value) {
                                    //     setModalState(() {
                                    //       tempSelectedLevel = value;
                                    //     });
                                    //   },
                                    // ),
                                    SizedBox(height: SizeConfig.h(0.020)),

                                    _AcademicGroupHeader(
                                      title: 'معهد',
                                      icon: AppImage.journals,
                                    ),

                                    SizedBox(height: SizeConfig.h(0.010)),

                                    _AcademicOptionsGrid(
                                      options: const [
                                        'سنة اولى معهد',
                                        'سنة ثانية معهد',
                                        'سنة ثالثة معهد',
                                      ],
                                      selectedLevel: tempSelectedLevel,
                                      onSelected: (value) {
                                        setModalState(() {
                                          tempSelectedLevel = value;
                                        });
                                      },
                                    ),

                                    SizedBox(height: SizeConfig.h(0.020)),

                                    _AcademicGroupHeader(
                                      title: 'أخرى',
                                      icon: AppImage.shapes,
                                    ),

                                    SizedBox(height: SizeConfig.h(0.010)),

                                    _AcademicOptionsGrid(
                                      options: const [
                                        'معلومات عامة',
                                        'ماجستير',
                                        'دكتوراه',
                                      ],
                                      selectedLevel: tempSelectedLevel,
                                      onSelected: (value) {
                                        setModalState(() {
                                          tempSelectedLevel = value;
                                        });
                                      },
                                    ),

                                    SizedBox(height: SizeConfig.h(0.020)),
                                  ],
                                ),
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.only(
                                left: SizeConfig.w(0.04),
                                right: SizeConfig.w(0.04),
                                top: SizeConfig.h(0.010),
                                bottom: SizeConfig.h(0.014),
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppPalette.fieldColorNDark
                                    : AppPalette.white,
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
                                  onPressed: tempSelectedLevel.trim().isEmpty
                                      ? null
                                      : () {
                                          cubit.changeAcademicLevel(
                                            tempSelectedLevel,
                                          );
                                          Navigator.of(dialogContext).pop();
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        appColors.primaryToPrimaryDark,
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
                                    color: tempSelectedLevel.trim().isEmpty
                                        ? AppPalette.greyMedium
                                        : isDark
                                        ? AppPalette.black
                                        : AppPalette.white,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
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

class _AcademicGroupHeader extends StatelessWidget {
  final String title;
  final String icon;

  const _AcademicGroupHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        CustomAppImage(
          path: icon,

          //  height: SizeConfig.h(23),
          //  width: SizeConfig.w(23),
          color: isDark
              ? AppPalette.textWhiteINDark
              : AppPalette.textColorInHome,
        ),
        SizedBox(width: SizeConfig.w(0.016)),
        CustomTextWidget(
          title,
          fontSize: SizeConfig.text(0.046),
          fontWeight: FontWeight.w600,
          color: isDark
              ? AppPalette.textWhiteINDark
              : AppPalette.textColorInHome,
          textAlign: TextAlign.right,
        ),
        const Spacer(),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          size: SizeConfig.text(0.063),
          color: isDark
              ? AppPalette.textWhiteINDark
              : AppPalette.textColorInHome,
        ),
      ],
    );
  }
}

class _AcademicStageTitle extends StatelessWidget {
  final String title;

  const _AcademicStageTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: SizeConfig.h(0.037),
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? AppPalette.greyLightDark : AppPalette.grey,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : AppPalette.borderFieldColorNLight,
          width: 1,
        ),
      ),
      child: CustomTextWidget(
        title,
        fontSize: SizeConfig.text(0.036),
        fontWeight: FontWeight.w500,
        color: isDark ? AppPalette.textWhiteINDark : AppPalette.grey2,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _AcademicOptionsGrid extends StatelessWidget {
  final List<String> options;
  final String selectedLevel;
  final ValueChanged<String> onSelected;

  const _AcademicOptionsGrid({
    required this.options,
    required this.selectedLevel,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: options.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: SizeConfig.h(0.008),
        crossAxisSpacing: SizeConfig.w(0.025),
        childAspectRatio: 4.25,
      ),
      itemBuilder: (context, index) {
        final option = options[index];

        return _AcademicLevelTile(
          level: option,
          selected: selectedLevel == option,
          onTap: () => onSelected(option),
        );
      },
    );
  }
}

class _AcademicLevelTile extends StatelessWidget {
  final String level;
  final bool selected;
  final VoidCallback onTap;

  const _AcademicLevelTile({
    required this.level,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: SizeConfig.h(0.036),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.020)),
        decoration: BoxDecoration(
          color: selected
              ? isDark
                    ? AppPalette.fieldColorNDark
                    : AppPalette.white
              : isDark
              ? AppPalette.fieldColorNDark
              : AppPalette.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: selected
                ? isDark
                      ? AppPalette.primaryDark
                      : AppPalette.homeContainer1
                : isDark
                ? AppPalette.borderFieldColorNDark
                : AppPalette.borderFieldColorNLight,
            width: selected ? 1.2 : 1.1,
          ),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            _AcademicRadio(selected: selected),
            SizedBox(width: SizeConfig.w(0.012)),
            Expanded(
              child: CustomTextWidget(
                level,
                fontSize: SizeConfig.text(0.028),
                fontWeight: FontWeight.w500,
                color: selected
                    ? isDark
                          ? AppPalette.primaryDark
                          : AppPalette.homeContainer1
                    : isDark
                    ? AppPalette.textWhiteINDark
                    : AppPalette.textColorInHome,
                textAlign: TextAlign.right,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AcademicRadio extends StatelessWidget {
  final bool selected;

  const _AcademicRadio({required this.selected});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: SizeConfig.w(0.033),
      height: SizeConfig.w(0.033),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? isDark
                    ? AppPalette.primaryDark
                    : AppPalette.homeContainer1
              : isDark
              ? AppPalette.borderFieldColorNDark
              : AppPalette.borderFieldColorNLight,
          width: 1.2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: SizeConfig.w(0.020),
                height: SizeConfig.w(0.020),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppPalette.primaryDark
                      : AppPalette.homeContainer1,
                ),
              ),
            )
          : null,
    );
  }
}

class _AcademicDashedDivider extends StatelessWidget {
  const _AcademicDashedDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      width: double.infinity,
      child: CustomPaint(painter: _AcademicDashedLinePainter()),
    );
  }
}

class _AcademicDashedLinePainter extends CustomPainter {
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
