import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_cubit.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_initial_args.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_state.dart';

class CreateTestHeader extends StatelessWidget {
  const CreateTestHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.h(0.03),
        right: SizeConfig.w(0.03),
        left: SizeConfig.w(0.02),
        bottom: SizeConfig.h(0.018),
      ),
      child: SizedBox(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            BlocBuilder<CreateTestCubit, CreateTestState>(
              buildWhen: (previous, current) {
                return previous.creationMode != current.creationMode ||
                    previous.isEditMode != current.isEditMode;
              },
              builder: (context, state) {
                return CustomTextWidget(
                  state.headerTitle,
                  fontSize: SizeConfig.text(0.05),
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppPalette.textWhiteINDark
                      : AppPalette.textColorInHome,
                  textAlign: TextAlign.center,
                );
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  showExitCreateTestDialog(context);
                },
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  width: SizeConfig.w(0.095),
                  height: SizeConfig.w(0.095),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppPalette.fieldColorNDark
                        : AppPalette.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? AppPalette.fieldColorNDark
                          : AppPalette.primaryToWhite,
                      width: 1.2,
                    ),
                  ),
                  child: Icon(
                    Icons.close,
                    size: SizeConfig.text(0.045),
                    color: isDark
                        ? AppPalette.textWhiteINDark
                        : AppPalette.textColorInHome,
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

Future<void> showExitCreateTestDialog(BuildContext context) {
  final parentContext = context;
  final cubit = context.read<CreateTestCubit>();

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'exit_create_test_dialog',
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
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: const SizedBox.expand(),
              ),
            ),
            Center(
              child: Material(
                color: Colors.transparent,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    width: SizeConfig.w(0.90),
                    padding: EdgeInsets.only(
                      left: SizeConfig.w(0.050),
                      right: SizeConfig.w(0.050),
                      top: SizeConfig.h(0.024),
                      bottom: SizeConfig.h(0.020),
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? AppPalette.black : AppPalette.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark
                            ? AppPalette.borderFieldColorNDark
                            : AppPalette.borderFieldColorNLight,
                      ),
                    ),
                    child: _ExitCreateTestDialogContent(
                      parentContext: parentContext,
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

      return FadeTransition(
        opacity: curvedAnimation,
        child: Transform.scale(
          scale: 0.96 + (curvedAnimation.value * 0.04),
          child: child,
        ),
      );
    },
  );
}

// Future<void> showExitCreateTestDialog(BuildContext context) {
//   return showGeneralDialog<void>(
//     context: context,
//     barrierDismissible: true,
//     barrierLabel: 'exit_create_test_dialog',
//     barrierColor: Colors.black.withOpacity(0.18),
//     transitionDuration: const Duration(milliseconds: 220),
//     pageBuilder: (dialogContext, animation, secondaryAnimation) {
//       final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

//       return Stack(
//         children: [
//           Positioned.fill(
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//               child: const SizedBox.expand(),
//             ),
//           ),

//           Center(
//             child: Material(
//               color: Colors.transparent,
//               child: Directionality(
//                 textDirection: TextDirection.rtl,
//                 child: Container(
//                   width: SizeConfig.w(0.90),
//                   padding: EdgeInsets.only(
//                     left: SizeConfig.w(0.050),
//                     right: SizeConfig.w(0.050),
//                     top: SizeConfig.h(0.024),
//                     bottom: SizeConfig.h(0.020),
//                   ),
//                   decoration: BoxDecoration(
//                     color: isDark ? AppPalette.black : AppPalette.white,
//                     borderRadius: BorderRadius.circular(14),
//                     border: Border.all(
//                       color: isDark
//                           ? AppPalette.borderFieldColorNDark
//                           : AppPalette.borderFieldColorNLight,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(isDark ? 0.35 : 0.18),
//                         blurRadius: 18,
//                         offset: const Offset(0, 8),
//                       ),
//                     ],
//                   ),
//                   child: const _ExitCreateTestDialogContent(),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     },
//     transitionBuilder: (context, animation, secondaryAnimation, child) {
//       final curvedAnimation = CurvedAnimation(
//         parent: animation,
//         curve: Curves.easeOutCubic,
//       );

//       return FadeTransition(
//         opacity: curvedAnimation,
//         child: Transform.scale(
//           scale: 0.96 + (curvedAnimation.value * 0.04),
//           child: child,
//         ),
//       );
//     },
//   );
// }
class _ExitCreateTestDialogContent extends StatelessWidget {
  final BuildContext parentContext;

  const _ExitCreateTestDialogContent({required this.parentContext});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;
    final state = context.read<CreateTestCubit>().state;
    final isEditMode = state.isEditMode;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: SizeConfig.w(0.120),
            height: SizeConfig.w(0.120),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? AppPalette.fieldColorNDark
                  : AppPalette.primarySoft,
            ),
            child: Icon(
              Icons.exit_to_app_rounded,
              size: SizeConfig.text(0.060),
              color: appColors.primaryToPrimaryDark,
            ),
          ),
        ),

        SizedBox(height: SizeConfig.h(0.018)),

        CustomTextWidget(
          isEditMode
              ? 'هل تريد مغادرة صفحة تعديل الاختبار ؟'
              : 'هل تريد مغادرة صفحة إنشاء الاختبار ؟',
          fontSize: SizeConfig.text(0.040),
          fontWeight: FontWeight.w900,
          color: isDark
              ? AppPalette.textWhiteINDark
              : AppPalette.textColorInHome,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          maxLines: 2,
        ),

        SizedBox(height: SizeConfig.h(0.008)),

        CustomTextWidget(
          isEditMode
              ? 'في حال غادرت هذه الصفحة ستخسر جميع التعديلات التي قمت بها على هذا الاختبار'
              : 'في حال غادرت هذه الصفحة ستخسر جميع البيانات التي قمت بإدخالها لإنشاء هذا الاختبار',
          fontSize: SizeConfig.text(0.030),
          fontWeight: FontWeight.w600,
          color: isDark ? AppPalette.grey2Dark : AppPalette.greyMedium,
          textAlign: TextAlign.right,
          maxLines: 3,
        ),

        SizedBox(height: SizeConfig.h(0.026)),

        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: SizeConfig.h(0.046),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();

                    if (parentContext.canPop()) {
                      parentContext.pop();
                    } else {
                      parentContext.goNamed(AppRouterName.mainLayout);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColors.primaryToPrimaryDark,
                    foregroundColor: isDark
                        ? AppPalette.black
                        : AppPalette.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: CustomTextWidget(
                    'مغادرة',
                    fontSize: SizeConfig.text(0.031),
                    fontWeight: FontWeight.w900,
                    color: isDark ? AppPalette.black : AppPalette.white,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(width: SizeConfig.w(0.045)),
            Expanded(
              child: SizedBox(
                height: SizeConfig.h(0.046),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isDark
                        ? AppPalette.fieldColorNDark
                        : AppPalette.white,
                    side: BorderSide(
                      color: isDark
                          ? AppPalette.borderFieldColorNDark
                          : AppPalette.borderFieldColorNLight,
                      width: 1.1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: CustomTextWidget(
                    'إلغاء',
                    fontSize: SizeConfig.text(0.031),
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
      ],
    );
  }
}
