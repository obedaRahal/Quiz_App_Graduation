import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_state.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/tests_tab/filter/my_profile_tests_filter_dialog.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/tests_tab/my_profile_tests_filter_section.dart';

class MyProfileTestsHeaderSection
    extends StatelessWidget {
  const MyProfileTestsHeaderSection({
    super.key,
  });

  Future<void> _openFilter(
    BuildContext context,
  ) async {
    final cubit =
        context.read<MyProfileCubit>();

    await cubit
        .getMyProfileTestsFilterInterests();

    if (!context.mounted) return;

    final state = cubit.state;

    if (state.testsFilterInterestsError !=
        null) {
      showValidationTopSnackBar(
        context,
        title: 'خطأ',
        message:
            'حدث خطأ أثناء جلب التصنيفات العلمية',
        type: AppValidationSnackBarType.error,
      );

      return;
    }

    final result =
        await showMyProfileTestsFilterDialog(
      context: context,
      interestCategories:
          state.testsFilterInterestCategories,
    );

    if (result == null ||
        !result.hasAnyFilter) {
      return;
    }

    await cubit.applyMyProfileTestsFilter(
      result.toParams(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
        MyProfileCubit,
        MyProfileState>(
      buildWhen: (previous, current) =>
          previous.selectedTestsTab !=
              current.selectedTestsTab ||
          previous.isTestsFilterMode !=
              current.isTestsFilterMode ||
          previous
                  .isTestsFilterInterestsLoading !=
              current
                  .isTestsFilterInterestsLoading,
      builder: (context, state) {
        final isDark =
            Theme.of(context).brightness ==
            Brightness.dark;

        return Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment:
              CrossAxisAlignment.center,
          children: [
            Expanded(
              child:
                  MyProfileTestsFilterSection(
                selectedTab:
                    state.selectedTestsTab,
                onTabSelected: context
                    .read<MyProfileCubit>()
                    .changeMyProfileTestsTab,
              ),
            ),

            SizedBox(
              width: SizeConfig.w(0.02),
            ),

            InkWell(
              onTap: state
                      .isTestsFilterInterestsLoading
                  ? null
                  : () => _openFilter(context),
              borderRadius:
                  BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 180,
                ),
                width: SizeConfig.w(0.085),
                height: SizeConfig.w(0.085),
                decoration: BoxDecoration(
                  color: state.isTestsFilterMode
                      ? context
                          .appColors
                          .primaryToPrimaryDark
                      : isDark
                          ? AppPalette
                              .fieldColorNDark
                          : AppPalette
                              .whiteToGrey,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: state
                        .isTestsFilterInterestsLoading
                    ? Padding(
                        padding: EdgeInsets.all(
                          SizeConfig.w(0.022),
                        ),
                        child:
                            const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        Icons
                            .filter_alt_outlined,
                        size:
                            SizeConfig.text(0.045),
                        color: state
                                .isTestsFilterMode
                            ? AppPalette.white
                            : AppPalette
                                .greyMedium,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}