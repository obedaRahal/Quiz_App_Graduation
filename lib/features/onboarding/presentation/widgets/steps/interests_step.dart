import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_state.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/interests/interest_group_section.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/interests/interests_models.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/interests/selected_interests_wrap.dart';

import '../../../../../../core/theme/color/app_colors.dart';
import '../../../../../../core/utils/media_query_config.dart';


class InterestsStep extends StatelessWidget {
  const InterestsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      buildWhen: (previous, current) =>
          previous.selectedInterestIds != current.selectedInterestIds ||
          previous.interestGroups != current.interestGroups ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        final selectedItems = _buildSelectedItems(
          selectedIds: state.selectedInterestIds,
          groups: state.interestGroups,
        );

        if (state.interestGroups.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.03)),
            child: Center(
              child: CustomTextWidget(
                'لا توجد اهتمامات متاحة حاليًا',
                color: AppPalette.greyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SelectedInterestsWrap(
              selectedItems: selectedItems,
              onRemove: (item) {
                context.read<OnboardingCubit>().toggleInterest(item.id);
              },
            ),

            if (selectedItems.isNotEmpty)
              SizedBox(height: SizeConfig.h(0.025)),

            ...state.interestGroups.map((group) {
              return Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.h(0.025)),
                child: InterestGroupSection(
                  group: group,
                  selectedInterestIds: state.selectedInterestIds,
                  onToggle: (item) {
                    context.read<OnboardingCubit>().toggleInterest(item.id);
                  },
                ),
              );
            }),

            if (state.errorMessage != null &&
                state.errorMessage!.trim().isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.h(0.01)),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CustomTextWidget(
                    state.errorMessage!,
                    color: Colors.red,
                    fontSize: SizeConfig.text(0.028),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  List<InterestOption> _buildSelectedItems({
    required List<int> selectedIds,
    required List<InterestGroupOption> groups,
  }) {
    if (selectedIds.isEmpty || groups.isEmpty) {
      return const [];
    }

    final allItems = _flattenInterests(groups);

    return selectedIds.map((id) {
      try {
        return allItems.firstWhere((item) => item.id == id);
      } catch (_) {
        return null;
      }
    }).whereType<InterestOption>().toList();
  }

  List<InterestOption> _flattenInterests(List<InterestGroupOption> groups) {
    return groups.expand((group) => group.items).toList();
  }
}


