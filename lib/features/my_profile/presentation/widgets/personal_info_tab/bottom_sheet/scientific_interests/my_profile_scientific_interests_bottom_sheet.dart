import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/get_all_interests/domain/entities/all_interests_response_entity.dart';
import 'package:quiz_app_grad/features/get_all_interests/presentation/manager/all_categories_cubit/all_interests_cubit.dart';
import 'package:quiz_app_grad/features/get_all_interests/presentation/manager/all_categories_cubit/all_interests_state.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_entity.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/personal_info_tab/bottom_sheet/scientific_interests/my_profile_interest_category_group.dart';

Future<void> showMyProfileScientificInterestsBottomSheet({
  required BuildContext context,
  required AllInterestsCubit cubit,
  required List<MyProfileScientificInterestEntity> initialSelected,
  required Future<bool> Function(List<InterestItemEntity> selectedInterests)
  onSave,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return BlocProvider.value(
        value: cubit..getAllInterests(),
        child: MyProfileScientificInterestsBottomSheet(
          initialSelected: initialSelected,
          onSave: onSave,
        ),
      );
    },
  );
}

class MyProfileScientificInterestsBottomSheet extends StatefulWidget {
  final List<MyProfileScientificInterestEntity> initialSelected;
  final Future<bool> Function(List<InterestItemEntity> selectedInterests)
  onSave;

  const MyProfileScientificInterestsBottomSheet({
    super.key,
    required this.initialSelected,
    required this.onSave,
  });

  @override
  State<MyProfileScientificInterestsBottomSheet> createState() =>
      _MyProfileScientificInterestsBottomSheetState();
}

class _MyProfileScientificInterestsBottomSheetState
    extends State<MyProfileScientificInterestsBottomSheet> {
  late final Set<int> selectedIds;

  int get selectedCount => selectedIds.length;

  bool isSaving = false;

  Set<int> get initialSelectedIds {
    return widget.initialSelected.map((item) => item.id).toSet();
  }

  bool get hasChanges {
    return !_setEquals(selectedIds, initialSelectedIds);
  }

  bool _setEquals(Set<int> a, Set<int> b) {
    if (a.length != b.length) return false;
    for (final item in a) {
      if (!b.contains(item)) return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    selectedIds = widget.initialSelected.map((item) => item.id).toSet();
  }

  void _toggleInterest(InterestItemEntity interest) {
    setState(() {
      if (selectedIds.contains(interest.id)) {
        selectedIds.remove(interest.id);
        return;
      }

      if (selectedIds.length >= 5) {
        showValidationTopSnackBar(
          context,
          title: 'تنبيه',
          message: 'يمكن اختيار خمسة اهتمامات كحد أقصى',
          type: AppValidationSnackBarType.hint,
        );
        return;
      }

      selectedIds.add(interest.id);
    });
  }

  Future<void> _save() async {
    if (isSaving || !hasChanges) return;

    if (selectedCount < 2) {
      showValidationTopSnackBar(
        context,
        title: 'تنبيه',
        message: 'يجب اختيار اهتمامين على الأقل',
        type: AppValidationSnackBarType.hint,
      );
      return;
    }

    final categories = context.read<AllInterestsCubit>().state.categories;
    final selectedInterests = <InterestItemEntity>[];

    for (final category in categories) {
      for (final interest in category.interests) {
        if (selectedIds.contains(interest.id)) {
          selectedInterests.add(interest);
        }
      }
    }

    setState(() => isSaving = true);

    final success = await widget.onSave(selectedInterests);

    if (!mounted) return;

    setState(() => isSaving = false);

    if (success) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canSave = selectedCount >= 2 && hasChanges && !isSaving;

    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.82,
        minChildSize: 0.45,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1F1F1F) : AppPalette.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Column(
              children: [
                SizedBox(height: SizeConfig.h(0.012)),
      
                Container(
                  width: SizeConfig.w(0.12),
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppPalette.greyMedium.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
      
                SizedBox(height: SizeConfig.h(0.018)),
      
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomBackgroundWithChild(
                        backgroundColor:
                            context.appColors.primarySoftTogreyLightDark,
                        borderRadius: BorderRadius.circular(20),
                        childHorizontalPad: SizeConfig.w(0.035),
                        childVerticalPad: SizeConfig.h(0.004),
                        child: CustomTextWidget(
                          '$selectedCount / 5',
                          color: context.appColors.primaryToPrimaryDark,
                          fontFamily: AppFont.elMessiriBold,
                          fontSize: SizeConfig.text(0.03),
                        ),
                      ),
      
                      CustomTextWidget(
                        'الاهتمامات العلمية',
                        color: context.appColors.blackTogreyMedium,
                        fontFamily: AppFont.elMessiriBold,
                        fontSize: SizeConfig.text(0.04),
                      ),
                    ],
                  ),
                ),
      
                CustomDivider(height: 20, thickness: 3, isDashed: true),
      
                Expanded(
                  child: BlocBuilder<AllInterestsCubit, AllInterestsState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
      
                      if (state.errorMessage != null) {
                        return Center(
                          child: CustomTextWidget(
                            'حدث خطأ أثناء جلب الاهتمامات',
                            color: AppPalette.greyMedium,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
      
                      if (state.filteredCategories.isEmpty) {
                        return Center(
                          child: CustomTextWidget(
                            'لا توجد اهتمامات متاحة',
                            color: AppPalette.greyMedium,
                            fontSize: SizeConfig.text(0.035),
                          ),
                        );
                      }
      
                      return ListView.separated(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.w(0.045),
                          vertical: SizeConfig.h(0.01),
                        ),
                        itemCount: state.filteredCategories.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: SizeConfig.h(0.022)),
                        itemBuilder: (context, index) {
                          return MyProfileInterestCategoryGroup(
                            category: state.filteredCategories[index],
                            selectedIds: selectedIds,
                            onInterestTap: _toggleInterest,
                          );
                        },
                      );
                    },
                  ),
                ),
      
                CustomBackgroundWithChild(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.w(0.03),
                    vertical: SizeConfig.h(0.017),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? AppPalette.greyMediumDark
                          : AppPalette.greyBorderCart,
                      blurRadius: 4,
                      offset: const Offset(0, -4),
                    ),
                  ],
                  backgroundColor: context.appColors.whiteToblack,
                  child: CustomButtonWidget(
                    width: double.infinity,
                    backgroundColor: canSave
                        ? context.appColors.primaryToPrimaryDark
                        : AppPalette.greyMedium.withOpacity(0.45),
                    childHorizontalPad: SizeConfig.w(0.04),
                    childVerticalPad: SizeConfig.w(0.013),
                    borderRadius: 6,
                    onTap: canSave ? _save : () {},
                    child: isSaving
                        ? SizedBox(
                            width: SizeConfig.w(0.05),
                            height: SizeConfig.w(0.05),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppPalette.white,
                            ),
                          )
                        : CustomTextWidget(
                            'حفظ',
                            fontSize: SizeConfig.text(0.03),
                            color: AppPalette.white,
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
