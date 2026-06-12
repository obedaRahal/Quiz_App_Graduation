import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_cubit.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_state.dart';

Future<void> showCreateTestOptionsSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required T selectedItem,
  required String Function(T item) itemLabel,
  required ValueChanged<T> onSelected,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'create_test_options_sheet',
    barrierColor: Colors.black.withOpacity(0.18),
    transitionDuration: const Duration(milliseconds: 240),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

      return Stack(
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
                  constraints: BoxConstraints(
                    maxHeight: SizeConfig.h(0.62),
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? AppPalette.black : AppPalette.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    border: Border.all(
                      color: isDark
                          ? AppPalette.borderFieldColorNDark
                          : Colors.transparent,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.24 : 0.10),
                        blurRadius: 18,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  child: _CreateTestOptionsSheetContent<T>(
                    title: title,
                    items: items,
                    selectedItem: selectedItem,
                    itemLabel: itemLabel,
                    onSelected: onSelected,
                  ),
                ),
              ),
            ),
          ),
        ],
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
        child: FadeTransition(
          opacity: curvedAnimation,
          child: child,
        ),
      );
    },
  );
}

class _CreateTestOptionsSheetContent<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final T selectedItem;
  final String Function(T item) itemLabel;
  final ValueChanged<T> onSelected;

  const _CreateTestOptionsSheetContent({
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.itemLabel,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: SizeConfig.h(0.010)),

        Container(
          width: SizeConfig.w(0.13),
          height: SizeConfig.h(0.0045),
          decoration: BoxDecoration(
            color: isDark ? AppPalette.greyLightDark : AppPalette.smallContainerGrey,
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        SizedBox(height: SizeConfig.h(0.010)),

        SizedBox(
          height: SizeConfig.h(0.046),
          width: double.infinity,
          child: Center(
            child: CustomTextWidget(
              title,
              fontSize: SizeConfig.text(0.044),
              fontWeight: FontWeight.w900,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
              textAlign: TextAlign.center,
            ),
          ),
        ),

        const _PickerDashedDivider(),

        Flexible(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.w(0.040),
              vertical: SizeConfig.h(0.014),
            ),
            itemCount: items.length,
            separatorBuilder: (context, index) {
              return SizedBox(height: SizeConfig.h(0.010));
            },
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = item == selectedItem;

              return _CreateTestOptionTile(
                title: itemLabel(item),
                isSelected: isSelected,
                onTap: () {
                  onSelected(item);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),

        SizedBox(height: SizeConfig.h(0.014)),
      ],
    );
  }
}

class _CreateTestOptionTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _CreateTestOptionTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    final backgroundColor = isSelected
        ? (isDark ? AppPalette.greyLightDark : AppPalette.primarySoft)
        : (isDark ? AppPalette.fieldColorNDark : AppPalette.white);

    final borderColor = isSelected
        ? appColors.primaryToPrimaryDark
        : (isDark
            ? AppPalette.borderFieldColorNDark
            : AppPalette.borderFieldColorNLight);

    final textColor = isSelected
        ? appColors.primaryToPrimaryDark
        : (isDark ? AppPalette.textWhiteINDark : AppPalette.textColorInHome);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: SizeConfig.h(0.046),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.035)),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 1.2 : 1,
          ),
        ),
        child: Row(
          children: [
            _PickerRadio(isSelected: isSelected),

            SizedBox(width: SizeConfig.w(0.026)),

            Expanded(
              child: CustomTextWidget(
                title,
                fontSize: SizeConfig.text(0.031),
                fontWeight: FontWeight.w800,
                color: textColor,
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

class _PickerRadio extends StatelessWidget {
  final bool isSelected;

  const _PickerRadio({
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return Container(
      width: SizeConfig.w(0.038),
      height: SizeConfig.w(0.038),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? appColors.primaryToPrimaryDark
              : (isDark ? AppPalette.grey2Dark : AppPalette.grey2),
          width: 1.3,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: SizeConfig.w(0.022),
                height: SizeConfig.w(0.022),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appColors.primaryToPrimaryDark,
                ),
              ),
            )
          : null,
    );
  }
}

Future<void> showCreateTestDurationDialog(BuildContext context) {
  final cubit = context.read<CreateTestCubit>();

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'create_test_duration_dialog',
    barrierColor: Colors.black.withOpacity(0.18),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

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

            Center(
              child: Material(
                color: Colors.transparent,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    width: SizeConfig.w(0.88),
                    constraints: BoxConstraints(
                      maxHeight: SizeConfig.h(0.52),
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? AppPalette.black : AppPalette.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark
                            ? AppPalette.borderFieldColorNDark
                            : Colors.transparent,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.28 : 0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const _CreateTestDurationDialogContent(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return Transform.scale(
        scale: 0.96 + (animation.value * 0.04),
        child: Opacity(opacity: animation.value, child: child),
      );
    },
  );
}

// class _CreateTestDurationDialogContent extends StatefulWidget {
//   const _CreateTestDurationDialogContent();

//   @override
//   State<_CreateTestDurationDialogContent> createState() =>
//       _CreateTestDurationDialogContentState();
// }

// class _CreateTestDurationDialogContentState
//     extends State<_CreateTestDurationDialogContent> {
//   late FixedExtentScrollController _hoursController;
//   late FixedExtentScrollController _minutesController;

//   static const int _minDurationMinutes = 10;
//   static const int _maxDurationMinutes = 180;

//   @override
//   void initState() {
//     super.initState();

//     final cubit = context.read<CreateTestCubit>();
//     final initialMinutes = cubit.state.pendingDurationMinutes.clamp(
//       _minDurationMinutes,
//       _maxDurationMinutes,
//     );

//     final initialHours = initialMinutes ~/ 60;
//     final initialRemainMinutes = initialMinutes % 60;

//     _hoursController = FixedExtentScrollController(initialItem: initialHours);
//     _minutesController = FixedExtentScrollController(
//       initialItem: initialRemainMinutes,
//     );

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       cubit.changePendingDuration(
//         hours: initialHours,
//         minutes: initialRemainMinutes,
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _hoursController.dispose();
//     _minutesController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CreateTestCubit, CreateTestState>(
//       buildWhen: (previous, current) {
//         return previous.pendingDurationMinutes != current.pendingDurationMinutes;
//       },
//       builder: (context, state) {
//         final isDark = Theme.of(context).brightness == Brightness.dark;
//         final appColors = context.appColors;

//         final pendingMinutes = state.pendingDurationMinutes.clamp(
//           _minDurationMinutes,
//           _maxDurationMinutes,
//         );

//         final hours = pendingMinutes ~/ 60;
//         final minutes = pendingMinutes % 60;

//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: SizeConfig.w(0.035),
//                 vertical: SizeConfig.h(0.012),
//               ),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Center(
//                     child: CustomTextWidget(
//                       'مؤقت',
//                       fontSize: SizeConfig.text(0.040),
//                       fontWeight: FontWeight.w900,
//                       color: isDark
//                           ? AppPalette.textWhiteINDark
//                           : AppPalette.textColorInHome,
//                       textAlign: TextAlign.center,
//                     ),
//                   ),

//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: InkWell(
//                       onTap: () => Navigator.of(context).pop(),
//                       borderRadius: BorderRadius.circular(30),
//                       child: Container(
//                         width: SizeConfig.w(0.080),
//                         height: SizeConfig.w(0.080),
//                         decoration: BoxDecoration(
//                           color: isDark
//                               ? AppPalette.fieldColorNDark
//                               : AppPalette.white,
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: isDark
//                                 ? AppPalette.borderFieldColorNDark
//                                 : AppPalette.primaryToWhite,
//                           ),
//                         ),
//                         child: Icon(
//                           Icons.close_rounded,
//                           size: SizeConfig.text(0.040),
//                           color: isDark
//                               ? AppPalette.titleWhiteINDark
//                               : AppPalette.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const _PickerDashedDivider(),

//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: SizeConfig.w(0.05),
//                 vertical: SizeConfig.h(0.014),
//               ),
//               child: Row(
//                 textDirection: TextDirection.ltr,
//                 children: [
//                   Expanded(
//                     child: _DurationWheel(
//                       title: 'دقائق',
//                       controller: _minutesController,
//                       itemCount: 60,
//                       selectedValue: minutes,
//                       itemLabel: (value) => value.toString().padLeft(2, '0'),
//                       onSelectedItemChanged: (value) {
//                         context.read<CreateTestCubit>().changePendingDuration(
//                               hours: hours,
//                               minutes: value,
//                             );
//                       },
//                     ),
//                   ),

//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: SizeConfig.w(0.030),
//                     ),
//                     child: CustomTextWidget(
//                       ':',
//                       fontSize: SizeConfig.text(0.070),
//                       fontWeight: FontWeight.w900,
//                       color: isDark
//                           ? AppPalette.textWhiteINDark
//                           : AppPalette.textColorInHome,
//                       textAlign: TextAlign.center,
//                     ),
//                   ),

//                   Expanded(
//                     child: _DurationWheel(
//                       title: 'ساعات',
//                       controller: _hoursController,
//                       itemCount: 4,
//                       selectedValue: hours,
//                       itemLabel: (value) => value.toString().padLeft(2, '0'),
//                       onSelectedItemChanged: (value) {
//                         context.read<CreateTestCubit>().changePendingDuration(
//                               hours: value,
//                               minutes: minutes,
//                             );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             Padding(
//               padding: EdgeInsets.only(
//                 left: SizeConfig.w(0.04),
//                 right: SizeConfig.w(0.04),
//                 bottom: SizeConfig.h(0.010),
//               ),
//               child: CustomTextWidget(
//                 'يمكنك اختيار مدة بين 10 دقائق و3 ساعات، أو تركها بدون مدة.',
//                 fontSize: SizeConfig.text(0.024),
//                 fontWeight: FontWeight.w600,
//                 color: isDark ? AppPalette.grey2Dark : AppPalette.greyMedium,
//                 textAlign: TextAlign.center,
//                 maxLines: 2,
//               ),
//             ),

//             Container(
//               padding: EdgeInsets.only(
//                 left: SizeConfig.w(0.04),
//                 right: SizeConfig.w(0.04),
//                 top: SizeConfig.h(0.010),
//                 bottom: SizeConfig.h(0.014),
//               ),
//               decoration: BoxDecoration(
//                 color: isDark ? AppPalette.black : AppPalette.white,
//                 border: Border(
//                   top: BorderSide(
//                     color: isDark
//                         ? AppPalette.borderFieldColorNDark
//                         : AppPalette.borderFieldColorNLight,
//                   ),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: SizedBox(
//                       height: SizeConfig.h(0.046),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           context.read<CreateTestCubit>().confirmDuration();
//                           Navigator.of(context).pop();
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: appColors.primaryToPrimaryDark,
//                           foregroundColor:
//                               isDark ? AppPalette.black : AppPalette.white,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(7),
//                           ),
//                         ),
//                         child: CustomTextWidget(
//                           'تأكيد',
//                           fontSize: SizeConfig.text(0.030),
//                           fontWeight: FontWeight.w900,
//                           color: isDark ? AppPalette.black : AppPalette.white,
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                   ),

//                   SizedBox(width: SizeConfig.w(0.025)),

//                   Expanded(
//                     child: SizedBox(
//                       height: SizeConfig.h(0.046),
//                       child: OutlinedButton(
//                         onPressed: () {
//                           context.read<CreateTestCubit>().clearDuration();
//                           Navigator.of(context).pop();
//                         },
//                         style: OutlinedButton.styleFrom(
//                           side: BorderSide(
//                             color: isDark
//                                 ? AppPalette.borderFieldColorNDark
//                                 : AppPalette.borderFieldColorNLight,
//                           ),
//                           backgroundColor: isDark
//                               ? AppPalette.fieldColorNDark
//                               : AppPalette.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(7),
//                           ),
//                         ),
//                         child: CustomTextWidget(
//                           'بدون مدة',
//                           fontSize: SizeConfig.text(0.030),
//                           fontWeight: FontWeight.w900,
//                           color: isDark
//                               ? AppPalette.textWhiteINDark
//                               : AppPalette.textColorInHome,
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class _DurationWheel extends StatelessWidget {
//   final String title;
//   final FixedExtentScrollController controller;
//   final int itemCount;
//   final int selectedValue;
//   final String Function(int value) itemLabel;
//   final ValueChanged<int> onSelectedItemChanged;

//   const _DurationWheel({
//     required this.title,
//     required this.controller,
//     required this.itemCount,
//     required this.selectedValue,
//     required this.itemLabel,
//     required this.onSelectedItemChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final appColors = context.appColors;

//     return Column(
//       children: [
//         CustomTextWidget(
//           title,
//           fontSize: SizeConfig.text(0.026),
//           fontWeight: FontWeight.w800,
//           color: isDark ? AppPalette.grey2Dark : AppPalette.greyMedium,
//           textAlign: TextAlign.center,
//         ),

//         SizedBox(height: SizeConfig.h(0.006)),

//         SizedBox(
//           height: SizeConfig.h(0.150),
//           child: ListWheelScrollView.useDelegate(
//             controller: controller,
//             itemExtent: SizeConfig.h(0.044),
//             physics: const FixedExtentScrollPhysics(),
//             diameterRatio: 1.6,
//             perspective: 0.004,
//             onSelectedItemChanged: onSelectedItemChanged,
//             childDelegate: ListWheelChildBuilderDelegate(
//               childCount: itemCount,
//               builder: (context, index) {
//                 final selected = index == selectedValue;

//                 return Center(
//                   child: CustomTextWidget(
//                     itemLabel(index),
//                     fontSize: selected
//                         ? SizeConfig.text(0.052)
//                         : SizeConfig.text(0.040),
//                     fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
//                     color: selected
//                         ? (isDark
//                             ? AppPalette.textWhiteINDark
//                             : AppPalette.textColorInHome)
//                         : (isDark ? AppPalette.greyLightDark : AppPalette.grey2),
//                     textAlign: TextAlign.center,
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),

//         SizedBox(height: SizeConfig.h(0.006)),

//         Container(
//           height: SizeConfig.h(0.030),
//           padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.030)),
//           decoration: BoxDecoration(
//             color: isDark ? AppPalette.fieldColorNDark : AppPalette.primarySoft,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: isDark
//                   ? AppPalette.borderFieldColorNDark
//                   : appColors.primaryToPrimaryDark,
//             ),
//           ),
//           child: Center(
//             child: CustomTextWidget(
//               itemLabel(selectedValue),
//               fontSize: SizeConfig.text(0.025),
//               fontWeight: FontWeight.w900,
//               color: appColors.primaryToPrimaryDark,
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
class _CreateTestDurationDialogContent extends StatefulWidget {
  const _CreateTestDurationDialogContent();

  @override
  State<_CreateTestDurationDialogContent> createState() =>
      _CreateTestDurationDialogContentState();
}

class _CreateTestDurationDialogContentState
    extends State<_CreateTestDurationDialogContent> {
  late FixedExtentScrollController _minutesController;
  late FixedExtentScrollController _secondsController;

  static const int _minMinutes = 10;
  static const int _maxMinutes = 180;

  @override
  void initState() {
    super.initState();

    final cubit = context.read<CreateTestCubit>();

    final initialTotalSeconds = cubit.state.pendingDurationSeconds.clamp(
      CreateTestCubit.minDurationSeconds,
      CreateTestCubit.maxDurationSeconds,
    );

    final initialMinutes = initialTotalSeconds ~/ 60;
    final initialSeconds = initialTotalSeconds % 60;

    _minutesController = FixedExtentScrollController(
      initialItem: initialMinutes - _minMinutes,
    );

    _secondsController = FixedExtentScrollController(
      initialItem: initialMinutes == _maxMinutes ? 0 : initialSeconds,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.changePendingDuration(
        minutes: initialMinutes,
        seconds: initialMinutes == _maxMinutes ? 0 : initialSeconds,
      );
    });
  }

  @override
  void dispose() {
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _changeDuration({
    required int minutes,
    required int seconds,
  }) {
    final normalizedSeconds = minutes == _maxMinutes ? 0 : seconds;

    if (minutes == _maxMinutes && seconds != 0) {
      _secondsController.animateToItem(
        0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    }

    context.read<CreateTestCubit>().changePendingDuration(
          minutes: minutes,
          seconds: normalizedSeconds,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTestCubit, CreateTestState>(
      buildWhen: (previous, current) {
        return previous.pendingDurationSeconds !=
            current.pendingDurationSeconds;
      },
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final appColors = context.appColors;

        final pendingSeconds = state.pendingDurationSeconds.clamp(
          CreateTestCubit.minDurationSeconds,
          CreateTestCubit.maxDurationSeconds,
        );

        final selectedMinutes = pendingSeconds ~/ 60;
        final selectedSeconds = selectedMinutes == _maxMinutes
            ? 0
            : pendingSeconds % 60;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(0.035),
                vertical: SizeConfig.h(0.012),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: CustomTextWidget(
                      'مؤقت',
                      fontSize: SizeConfig.text(0.040),
                      fontWeight: FontWeight.w900,
                      color: isDark
                          ? AppPalette.textWhiteINDark
                          : AppPalette.textColorInHome,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: SizeConfig.w(0.080),
                        height: SizeConfig.w(0.080),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppPalette.fieldColorNDark
                              : AppPalette.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AppPalette.borderFieldColorNDark
                                : AppPalette.primaryToWhite,
                          ),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: SizeConfig.text(0.040),
                          color: isDark
                              ? AppPalette.titleWhiteINDark
                              : AppPalette.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const _PickerDashedDivider(),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(0.05),
                vertical: SizeConfig.h(0.014),
              ),
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  Expanded(
                    child: _DurationWheel(
                      title: 'ثواني',
                      controller: _secondsController,
                      itemCount: selectedMinutes == _maxMinutes ? 1 : 60,
                      selectedValue: selectedSeconds,
                      itemLabel: (value) => value.toString().padLeft(2, '0'),
                      onSelectedItemChanged: (value) {
                        _changeDuration(
                          minutes: selectedMinutes,
                          seconds: value,
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(0.030),
                    ),
                    child: CustomTextWidget(
                      ':',
                      fontSize: SizeConfig.text(0.070),
                      fontWeight: FontWeight.w900,
                      color: isDark
                          ? AppPalette.textWhiteINDark
                          : AppPalette.textColorInHome,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Expanded(
                    child: _DurationWheel(
                      title: 'دقائق',
                      controller: _minutesController,
                      itemCount: _maxMinutes - _minMinutes + 1,
                      selectedValue: selectedMinutes,
                      itemLabel: (value) => value.toString().padLeft(2, '0'),
                      valueFromIndex: (index) => index + _minMinutes,
                      onSelectedItemChanged: (value) {
                        _changeDuration(
                          minutes: value,
                          seconds: selectedSeconds,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.w(0.04),
                right: SizeConfig.w(0.04),
                bottom: SizeConfig.h(0.010),
              ),
              child: CustomTextWidget(
                'يمكنك اختيار مدة بين 10:00 و 180:00 دقيقة.',
                fontSize: SizeConfig.text(0.024),
                fontWeight: FontWeight.w600,
                color: isDark ? AppPalette.grey2Dark : AppPalette.greyMedium,
                textAlign: TextAlign.center,
                maxLines: 2,
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
                color: isDark ? AppPalette.black : AppPalette.white,
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppPalette.borderFieldColorNDark
                        : AppPalette.borderFieldColorNLight,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: SizeConfig.h(0.046),
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<CreateTestCubit>().confirmDuration();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColors.primaryToPrimaryDark,
                          foregroundColor:
                              isDark ? AppPalette.black : AppPalette.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: CustomTextWidget(
                          'تأكيد',
                          fontSize: SizeConfig.text(0.030),
                          fontWeight: FontWeight.w900,
                          color: isDark ? AppPalette.black : AppPalette.white,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: SizeConfig.w(0.025)),

                  Expanded(
                    child: SizedBox(
                      height: SizeConfig.h(0.046),
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<CreateTestCubit>().clearDuration();
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isDark
                                ? AppPalette.borderFieldColorNDark
                                : AppPalette.borderFieldColorNLight,
                          ),
                          backgroundColor: isDark
                              ? AppPalette.fieldColorNDark
                              : AppPalette.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: CustomTextWidget(
                          'بدون مدة',
                          fontSize: SizeConfig.text(0.030),
                          fontWeight: FontWeight.w900,
                          color: isDark
                              ? AppPalette.textWhiteINDark
                              : AppPalette.textColorInHome,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DurationWheel extends StatelessWidget {
  final String title;
  final FixedExtentScrollController controller;
  final int itemCount;
  final int selectedValue;
  final String Function(int value) itemLabel;
  final ValueChanged<int> onSelectedItemChanged;
  final int Function(int index)? valueFromIndex;

  const _DurationWheel({
    required this.title,
    required this.controller,
    required this.itemCount,
    required this.selectedValue,
    required this.itemLabel,
    required this.onSelectedItemChanged,
    this.valueFromIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return Column(
      children: [
        CustomTextWidget(
          title,
          fontSize: SizeConfig.text(0.026),
          fontWeight: FontWeight.w800,
          color: isDark ? AppPalette.grey2Dark : AppPalette.greyMedium,
          textAlign: TextAlign.center,
        ),

        SizedBox(height: SizeConfig.h(0.006)),

        SizedBox(
          height: SizeConfig.h(0.150),
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: SizeConfig.h(0.044),
            physics: const FixedExtentScrollPhysics(),
            diameterRatio: 1.6,
            perspective: 0.004,
            onSelectedItemChanged: (index) {
              final value = valueFromIndex == null
                  ? index
                  : valueFromIndex!(index);

              onSelectedItemChanged(value);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: itemCount,
              builder: (context, index) {
                final value = valueFromIndex == null
                    ? index
                    : valueFromIndex!(index);

                final selected = value == selectedValue;

                return Center(
                  child: CustomTextWidget(
                    itemLabel(value),
                    fontSize: selected
                        ? SizeConfig.text(0.052)
                        : SizeConfig.text(0.040),
                    fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                    color: selected
                        ? (isDark
                            ? AppPalette.textWhiteINDark
                            : AppPalette.textColorInHome)
                        : (isDark
                            ? AppPalette.greyLightDark
                            : AppPalette.grey2),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
        ),

        SizedBox(height: SizeConfig.h(0.006)),

        Container(
          height: SizeConfig.h(0.030),
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.030)),
          decoration: BoxDecoration(
            color: isDark ? AppPalette.fieldColorNDark : AppPalette.primarySoft,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? AppPalette.borderFieldColorNDark
                  : appColors.primaryToPrimaryDark,
            ),
          ),
          child: Center(
            child: CustomTextWidget(
              itemLabel(selectedValue),
              fontSize: SizeConfig.text(0.025),
              fontWeight: FontWeight.w900,
              color: appColors.primaryToPrimaryDark,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
class _PickerDashedDivider extends StatelessWidget {
  const _PickerDashedDivider();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 1,
      width: double.infinity,
      child: CustomPaint(
        painter: _PickerDashedLinePainter(
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : AppPalette.greyMedium,
        ),
      ),
    );
  }
}

class _PickerDashedLinePainter extends CustomPainter {
  final Color color;

  const _PickerDashedLinePainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2;

    double x = 0;

    while (x < size.width) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + 9, 0),
        paint,
      );
      x += 15;
    }
  }

  @override
  bool shouldRepaint(covariant _PickerDashedLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}