import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/create_edit_folder/my_profile_picker_tests_entity.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_state.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_tests_entity.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_horizontal_filter_section.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/test_tab/other_profile_test_card.dart';

void showMyProfileTestsPickerBottomSheet({
  required BuildContext context,
  required int userId,
}) {
  final cubit = context.read<MyProfileFolderEditorCubit>();

  cubit.openPicker(userId: userId);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return BlocProvider.value(
        value: cubit,
        child: MyProfileTestsPickerBottomSheet(userId: userId),
      );
    },
  );
}

class MyProfileTestsPickerBottomSheet extends StatelessWidget {
  final int userId;

  const MyProfileTestsPickerBottomSheet({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: 0.86,
        minChildSize: 0.45,
        maxChildSize: 0.96,
        builder: (context, scrollController) {
          return CustomBackgroundWithChild(
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Column(
              children: [
                SizedBox(height: SizeConfig.h(0.012)),
      
                Container(
                  width: SizeConfig.w(0.12),
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppPalette.greyLightDark
                        : AppPalette.greyLight,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
      
                SizedBox(height: SizeConfig.h(0.014)),
      
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
                  child:
                      BlocBuilder<
                        MyProfileFolderEditorCubit,
                        MyProfileFolderEditorState
                      >(
                        buildWhen: (previous, current) =>
                            previous.tempSelectedTestIds !=
                            current.tempSelectedTestIds,
                        builder: (context, state) {
                          return Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              Expanded(
                                child: CustomTextWidget(
                                  '        اختباراتي',
                                  textAlign: TextAlign.center,
                                  fontFamily: AppFont.elMessiriBold,
                                  fontSize: SizeConfig.text(0.045),
                                  color: appColors.blackToGrey2Dark,
                                ),
                              ),
                              CustomBackgroundWithChild(
                                backgroundColor:
                                    appColors.primarySoftTogreyLightDark,
                                borderRadius: BorderRadius.circular(20),
                                childHorizontalPad: SizeConfig.w(0.025),
                                childVerticalPad: SizeConfig.h(0.002),
                                child: CustomTextWidget(
                                  '${state.tempSelectedTestIds.length}/10',
                                  color: appColors.primaryToPrimaryDark,
                                  fontSize: SizeConfig.text(0.026),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                ),
      
                SizedBox(height: SizeConfig.h(0.01)),
      
                const CustomDivider(height: 10, thickness: 2, isDashed: true),
      
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.035)),
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.h(0.012)),
      
                      _PickerSearchField(userId: userId),
      
                      SizedBox(height: SizeConfig.h(0.012)),
      
                      _PickerFilterSection(userId: userId),
                    ],
                  ),
                ),
      
                SizedBox(height: SizeConfig.h(0.01)),
      
                Expanded(
                  child: _PickerTestsList(
                    userId: userId,
                    scrollController: scrollController,
                  ),
                ),
      
                _PickerSaveButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PickerSearchField extends StatefulWidget {
  final int userId;

  const _PickerSearchField({
    required this.userId,
  });

  @override
  State<_PickerSearchField> createState() => _PickerSearchFieldState();
}

class _PickerSearchFieldState extends State<_PickerSearchField> {
  late final TextEditingController _controller;

  bool get hasText => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    final query = context
        .read<MyProfileFolderEditorCubit>()
        .state
        .pickerSearchQuery;

    _controller = TextEditingController(text: query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();

    context.read<MyProfileFolderEditorCubit>().changePickerSearchQuery(
          userId: widget.userId,
          value: '',
        );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: SizeConfig.h(0.052),
      child: TextField(
        controller: _controller,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        onChanged: (value) {
          context.read<MyProfileFolderEditorCubit>().changePickerSearchQuery(
                userId: widget.userId,
                value: value,
              );

          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'ابحث عن اختبار',
          hintTextDirection: TextDirection.rtl,
          suffixIcon: Icon(
            Icons.search_rounded,
            color: AppPalette.greyMedium,
            size: SizeConfig.text(0.05),
          ),
          prefixIcon: hasText
              ? InkWell(
                  onTap: _clear,
                  child: Icon(
                    Icons.close_rounded,
                    color: AppPalette.greyMedium,
                    size: SizeConfig.text(0.048),
                  ),
                )
              : null,
          hintStyle: TextStyle(
            color: AppPalette.greyMedium,
            fontFamily: AppFont.elMessiriRegular,
            fontSize: SizeConfig.text(0.03),
          ),
          filled: true,
          fillColor:
              isDark ? Colors.white.withOpacity(0.05) : AppPalette.grey,
          contentPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.03),
            vertical: SizeConfig.h(0.012),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: appColors.borderFieldColorNLightToborderFieldColorNDark,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: appColors.borderFieldColorNLightToborderFieldColorNDark,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: appColors.primaryToPrimaryDark),
          ),
        ),
      ),
    );
  }
}

class _PickerFilterSection extends StatelessWidget {
  final int userId;

  const _PickerFilterSection({required this.userId});

  static const filters = [
    OtherProfileFilterOption(
      title: 'عامة',
      value: MyProfilePickerTestsTab.public,
    ),
    OtherProfileFilterOption(
      title: 'خاصة',
      value: MyProfilePickerTestsTab.private,
    ),
    OtherProfileFilterOption(
      title: 'مدفوعة',
      value: MyProfilePickerTestsTab.paid,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileFolderEditorCubit, MyProfileFolderEditorState>(
      buildWhen: (previous, current) =>
          previous.selectedPickerTestsTab != current.selectedPickerTestsTab,
      builder: (context, state) {
        return OtherProfileHorizontalFilterSection<MyProfilePickerTestsTab>(
          selectedFilter: state.selectedPickerTestsTab,
          filters: filters,
          onFilterSelected: (tab) {
            context.read<MyProfileFolderEditorCubit>().changePickerTestsTab(
              userId: userId,
              tab: tab,
            );
          },
        );
      },
    );
  }
}

class _PickerTestsList extends StatelessWidget {
  final int userId;
  final ScrollController scrollController;

  const _PickerTestsList({
    required this.userId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileFolderEditorCubit, MyProfileFolderEditorState>(
      buildWhen: (previous, current) =>
          previous.pickerTestsStatus != current.pickerTestsStatus ||
          previous.pickerTestsLoadMoreStatus !=
              current.pickerTestsLoadMoreStatus ||
          previous.pickerTestsResponse != current.pickerTestsResponse ||
          previous.tempSelectedTestIds != current.tempSelectedTestIds ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        if (state.isPickerTestsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isPickerTestsFailure) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.w(0.05)),
              child: CustomTextWidget(
                state.errorMessage ?? 'حدث خطأ أثناء جلب الاختبارات',
                color: AppPalette.red,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (state.hasPickerSearchQuery) {
          context
              .read<MyProfileFolderEditorCubit>()
              .fetchMorePickerSearchIfNeeded();
        } else {
          context
              .read<MyProfileFolderEditorCubit>()
              .fetchMorePickerTestsIfNeeded(userId: userId);
        }

        final tests = state.hasPickerSearchQuery
            ? state.pickerSearchResponse?.data ?? []
            : state.pickerTestsResponse?.data ?? [];

        if (tests.isEmpty) {
          return Center(
            child: CustomTextWidget(
              'لا توجد اختبارات ضمن هذا التصنيف',
              color: AppPalette.greyMedium,
              textAlign: TextAlign.center,
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            final metrics = notification.metrics;
            if (metrics.maxScrollExtent <= 0) return false;

            final ratio = metrics.pixels / metrics.maxScrollExtent;
            if (ratio < 0.8) return false;

            context
                .read<MyProfileFolderEditorCubit>()
                .fetchMorePickerTestsIfNeeded(userId: userId);

            return false;
          },
          child: ListView.separated(
            controller: scrollController,
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.w(0.035),
              vertical: SizeConfig.h(0.012),
            ),
            itemCount: tests.length + (state.isPickerTestsLoadingMore ? 1 : 0),
            separatorBuilder: (_, __) => SizedBox(height: SizeConfig.h(0.012)),
            itemBuilder: (context, index) {
              if (index >= tests.length) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.018)),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              final test = tests[index];
              final isSelected = state.tempSelectedTestIds.contains(test.id);

              return MyProfilePickerTestCard(
                item: test,
                isSelected: isSelected,
                onTap: () {
                  context
                      .read<MyProfileFolderEditorCubit>()
                      .togglePickerTestSelection(test.id);
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _PickerSaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomBackgroundWithChild(
      childVerticalPad: SizeConfig.h(0.01),
      childHorizontalPad: SizeConfig.w(0.03),
      backgroundColor: appColors.whiteToblack,
      width: double.infinity,
      boxShadow: [
        BoxShadow(
          color: isDark ? AppPalette.greyMediumDark : AppPalette.greyBorderCart,
          blurRadius: 4,
          offset: const Offset(0, -4),
        ),
      ],
      child: CustomButtonWidget(
        width: double.infinity,
        backgroundColor: appColors.primaryToPrimaryDark,
        childHorizontalPad: SizeConfig.w(0.04),
        childVerticalPad: SizeConfig.w(0.013),
        borderRadius: 6,
        onTap: () {
          context.read<MyProfileFolderEditorCubit>().applyPickerSelection();
          Navigator.of(context).pop();
        },
        child: CustomTextWidget(
          'حفظ التغييرات',
          fontSize: SizeConfig.text(0.03),
          color: AppPalette.white,
        ),
      ),
    );
  }
}

class MyProfilePickerTestCard extends StatelessWidget {
  final MyProfilePickerTestItemEntity item;
  final bool isSelected;
  final VoidCallback onTap;

  const MyProfilePickerTestCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  String get priceText {
    if (item.price == 0) return '0';
    return item.price.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OtherProfileTestCard(
          item: OtherProfileTestItemEntity(
            id: item.id,
            title: item.title,
            description: item.description,
            interests: item.interestNames,
            difficultyLevel: item.targetLevel,
            averageRating: item.averageRating,
            price: priceText,
            publishedAt: item.publishedAt,
            questionCount: item.questionCount,
            targetLevel: item.targetLevel,
          ),
        ),
        Positioned(
          top: SizeConfig.h(0.01),
          right: SizeConfig.w(0.02),
          child: _CheckButton(isSelected: isSelected, onTap: onTap),
        ),
      ],
    );
  }
}

class _CheckButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _CheckButton({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.all(SizeConfig.w(0.008)),
        decoration: BoxDecoration(
          color: isSelected
              ? context.appColors.primaryToPrimaryDark
              : AppPalette.greyLight,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected
                ? context.appColors.primaryToPrimaryDark
                : AppPalette.greyMedium,
          ),
        ),
        child: Icon(
          isSelected ? Icons.check_rounded : Icons.add_rounded,
          color: isSelected ? AppPalette.white : AppPalette.greyMedium,
          size: SizeConfig.h(0.024),
        ),
      ),
    );
  }
}
