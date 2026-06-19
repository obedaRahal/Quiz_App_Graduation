import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/manager/laboratory_cubit/laboratory_cubit.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/manager/laboratory_cubit/laboratory_state.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_filter_bottom_sheet.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_filter_item.dart';

class LaboratoryTabsSection extends StatelessWidget {
  const LaboratoryTabsSection({super.key});

  int _indexFromTab(String tab) {
    switch (tab) {
      case 'trending':
        return 0;
      case 'free':
        return 3;
      case 'new':
        return 1;
      case 'most_participated':
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<LaboratoryCubit, LaboratoryState>(
      buildWhen: (previous, current) =>
          previous.selectedLabTab != current.selectedLabTab,
      builder: (context, state) {
        final selectedIndex = _indexFromTab(state.selectedLabTab);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.036)),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      child: LaboratoryFilterItem(
                        title: "رائج",
                        index: 0,
                        selectedIndex: selectedIndex,
                        onTap: () =>
                            context.read<LaboratoryCubit>().changeLabTab(0),
                      ),
                    ),
                    SizedBox(width: SizeConfig.w(0.018)),

                    Expanded(
                      child: LaboratoryFilterItem(
                        title: "مجاني",
                        index: 3,
                        selectedIndex: selectedIndex,
                        onTap: () =>
                            context.read<LaboratoryCubit>().changeLabTab(3),
                      ),
                    ),
                    SizedBox(width: SizeConfig.w(0.018)),

                    Expanded(
                      child: LaboratoryFilterItem(
                        title: "جديد",
                        index: 1,
                        selectedIndex: selectedIndex,
                        onTap: () =>
                            context.read<LaboratoryCubit>().changeLabTab(1),
                      ),
                    ),
                    SizedBox(width: SizeConfig.w(0.018)),

                    Expanded(
                      flex: 2,
                      child: LaboratoryFilterItem(
                        title: "الأكثر تقدما",
                        index: 2,
                        selectedIndex: selectedIndex,
                        onTap: () =>
                            context.read<LaboratoryCubit>().changeLabTab(2),
                      ),
                    ),

                    SizedBox(width: SizeConfig.w(0.092)),

                    InkWell(
                      onTap: () async {
                        final cubit = context.read<LaboratoryCubit>();

                        await cubit.getFilterInterests();

                        if (!context.mounted) return;

                        if (cubit.state.filterInterestsError != null) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: CustomTextWidget(
                                'حدث خطأ أثناء جلب التصنيفات العلمية',
                                color: AppPalette.white,
                              ),
                              backgroundColor: AppPalette.red,
                            ),
                          );
                          return;
                        }

                        final result = await showLaboratoryFilterBottomSheet(
                          context,
                          interestCategories:
                              cubit.state.filterInterestCategories,
                        );

                        if (result == null) return;

                        await cubit.applyFilter(result);
                      },
                      child: Container(
                        width: SizeConfig.w(0.075),
                        height: SizeConfig.w(0.075),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppPalette.fieldColorNDark
                              : AppPalette.whiteToGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.filter_alt_outlined,
                          size: SizeConfig.text(0.045),
                          color: AppPalette.greyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
