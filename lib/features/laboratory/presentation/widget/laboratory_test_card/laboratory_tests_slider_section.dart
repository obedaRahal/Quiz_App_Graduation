// import 'package:flutter/material.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';
// import 'package:quiz_app_grad/features/laboratory/data/models/laboratory_test_model.dart';
// import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_test_card/laboratory_test_card.dart';

// class LaboratoryTestsSliderSection extends StatelessWidget {
//   final PageController controller;
//   final bool isDark;
//   final dynamic appColors;
//   final dynamic colorScheme;

//   const LaboratoryTestsSliderSection({
//     super.key,
//     required this.controller,
//     required this.isDark,
//     required this.appColors,
//     required this.colorScheme,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SizedBox(
//         height: SizeConfig.isSmallPhone
//             ? SizeConfig.h(0.38)
//             : SizeConfig.isMediumPhone
//             ? SizeConfig.h(0.40)
//             : SizeConfig.h(0.43),
//         child: Directionality(
//           textDirection: TextDirection.rtl,
//           child: PageView.builder(
//             controller: controller,
//             padEnds: false,
//             itemCount: dummyLaboratoryTests.length,
//             itemBuilder: (context, index) {
//               return LaboratoryTestCard(
//                 item: dummyLaboratoryTests[index],
//                 isDark: isDark,
//                 appColors: appColors,
//                 colorScheme: colorScheme,
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/managet/laboratory_cubit/laboratory_cubit.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/managet/laboratory_cubit/laboratory_state.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_test_card/laboratory_test_card.dart';

class LaboratoryTestsSliderSection extends StatelessWidget {
  final PageController controller;
  final bool isDark;
  final dynamic appColors;
  final dynamic colorScheme;

  const LaboratoryTestsSliderSection({
    super.key,
    required this.controller,
    required this.isDark,
    required this.appColors,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LaboratoryCubit, LaboratoryState>(
      buildWhen: (previous, current) =>
          previous.isLabTestsLoading != current.isLabTestsLoading ||
          previous.labTestsError != current.labTestsError ||
          previous.featuredTopRatedTests != current.featuredTopRatedTests,
      builder: (context, state) {
        if (state.isLabTestsLoading) {
          return SizedBox(
            height: SizeConfig.h(0.40),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.labTestsError != null &&
            state.featuredTopRatedTests.isEmpty) {
          return SizedBox(
            height: SizeConfig.h(0.20),
            child: Center(
              child: CustomTextWidget(
                'حدث خطأ أثناء جلب الاختبارات',
                color: AppPalette.greyMedium,
              ),
            ),
          );
        }

        if (state.featuredTopRatedTests.isEmpty) {
          return SizedBox(
            height: SizeConfig.h(0.20),
            child: Center(
              child: CustomTextWidget(
                'لا توجد اختبارات حالياً',
                color: AppPalette.greyMedium,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: SizeConfig.isSmallPhone
                ? SizeConfig.h(0.38)
                : SizeConfig.isMediumPhone
                    ? SizeConfig.h(0.40)
                    : SizeConfig.h(0.43),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: PageView.builder(
                controller: controller,
                padEnds: false,
                itemCount: state.featuredTopRatedTests.length,
                itemBuilder: (context, index) {
                  return LaboratoryTestCard(
                    item: state.featuredTopRatedTests[index],
                    isDark: isDark,
                    appColors: appColors,
                    colorScheme: colorScheme,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}