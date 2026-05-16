import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/test_interaction_users_cubit/cubit/test_interaction_users_cubit.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/test_interaction_users_cubit/cubit/test_interaction_users_state.dart';

import '../../../../core/common_widgets/custom_text_widget.dart';
import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/utils/media_query_config.dart';
import '../../../../core/common_widgets/custom_divider.dart';
import '../../../../core/common_widgets/custom_button_widget.dart';

void showTestInteractionUsersBottomSheet({
  required BuildContext context,
  required int testId,
  required TestInteractionUsersCubit cubit,
  required TestInteractionUsersType type,
  String title = 'الأشخاص الذين أعجبوا بهذا الاختبار',
  String searchHint = 'ابحث عن مستخدم',
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return BlocProvider.value(
        value: cubit..getInitialUsers(testId: testId, type: type),
        child: TestInteractionUsersBottomSheet(
          testId: testId,
          type: type,
          title: title,
          searchHint: searchHint,
        ),
      );
    },
  );
}

class TestInteractionUsersBottomSheet extends StatelessWidget {
  final int testId;
  final TestInteractionUsersType type;
  final String title;
  final String searchHint;

  const TestInteractionUsersBottomSheet({
    super.key,
    required this.testId,
    required this.type,
    required this.title,
    required this.searchHint,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<TestInteractionUsersCubit, TestInteractionUsersState>(
      listenWhen: (previous, current) =>
          previous.loadMoreStatus != current.loadMoreStatus ||
          previous.followStatus != current.followStatus,
      listener: (context, state) {
        if (state.isLoadMoreFailure) {
          showValidationTopSnackBar(
            context,
            title: state.errorTitle ?? 'خطأ',
            message: state.errorMessage ?? 'تعذر تحميل المزيد من المستخدمين',
            type: AppValidationSnackBarType.error,
          );

          context.read<TestInteractionUsersCubit>().resetLoadMoreState();
        }

        if (state.isFollowFailure) {
          showValidationTopSnackBar(
            context,
            title: state.errorTitle ?? 'خطأ',
            message: state.errorMessage ?? 'تعذر تنفيذ عملية المتابعة',
            type: AppValidationSnackBarType.error,
          );

          context.read<TestInteractionUsersCubit>().resetFollowState();
        }
      },
      builder: (context, state) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.78,
          minChildSize: 0.45,
          maxChildSize: 0.92,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1F1F1F) : AppPalette.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(26),
                ),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.w(0.045),
                      ),
                      child: CustomTextWidget(
                        title,
                        color: appColors.blackTogreyMedium,
                        fontFamily: AppFont.elMessiriBold,
                        fontSize: SizeConfig.text(0.04),
                        textAlign: TextAlign.right,
                      ),
                    ),

                    //SizedBox(height: SizeConfig.h(0.014)),
                    CustomDivider(height: 20, thickness: 3, isDashed: true),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.w(0.045),
                      ),
                      child: _InteractionUsersSearchField(
                        hintText: searchHint,
                        onChanged: (value) {
                          context
                              .read<TestInteractionUsersCubit>()
                              .onSearchChanged(
                                testId: testId,
                                value: value,
                                type: type,
                              );
                        },
                      ),
                    ),

                    SizedBox(height: SizeConfig.h(0.012)),

                    Expanded(
                      child: _InteractionUsersContent(
                        testId: testId,
                        scrollController: scrollController,
                        type: type,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _InteractionUsersSearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  const _InteractionUsersSearchField({
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: SizeConfig.h(0.055),
      child: TextField(
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintTextDirection: TextDirection.rtl,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppPalette.greyMedium,
            size: SizeConfig.text(0.055),
          ),
          hintStyle: TextStyle(
            color: AppPalette.greyMedium,
            fontFamily: AppFont.elMessiriRegular,
            fontSize: SizeConfig.text(0.036),
          ),
          filled: true,
          fillColor: isDark ? Colors.white.withOpacity(0.05) : AppPalette.grey,
          contentPadding: EdgeInsets.symmetric(
            // horizontal: SizeConfig.w(0.035),
            // vertical: SizeConfig.h(0.012),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: appColors.borderFieldColorNLightToborderFieldColorNDark,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: appColors.borderFieldColorNLightToborderFieldColorNDark,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: appColors.primaryToPrimaryDark),
          ),
        ),
      ),
    );
  }
}

class _InteractionUsersContent extends StatelessWidget {
  final int testId;
  final ScrollController scrollController;
  final TestInteractionUsersType type;

  const _InteractionUsersContent({
    required this.testId,
    required this.scrollController,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestInteractionUsersCubit, TestInteractionUsersState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.loadMoreStatus != current.loadMoreStatus ||
          previous.followStatus != current.followStatus ||
          previous.users != current.users ||
          previous.activeFollowUserId != current.activeFollowUserId ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        if (state.isInitialLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isFailure && state.users.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.08)),
              child: CustomTextWidget(
                state.errorMessage ?? 'تعذر جلب المستخدمين',
                color: AppPalette.red,
                textAlign: TextAlign.center,
                fontSize: SizeConfig.text(0.034),
              ),
            ),
          );
        }

        if (state.users.isEmpty) {
          return Center(
            child: CustomTextWidget(
              state.hasSearchQuery
                  ? 'لا توجد نتائج مطابقة'
                  : 'لا يوجد مستخدمون لعرضهم',
              color: AppPalette.greyMedium,
              textAlign: TextAlign.center,
              fontSize: SizeConfig.text(0.034),
            ),
          );
        }

        return ListView.separated(
          controller: scrollController,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.045),
            vertical: SizeConfig.h(0.018),
          ),
          itemCount: state.users.length + (state.isLoadMoreLoading ? 1 : 0),
          separatorBuilder: (_, __) => SizedBox(height: SizeConfig.h(0.014)),
          itemBuilder: (context, index) {
            if (index >= state.users.length) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.015)),
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            final shouldLoadMore =
                index >= state.users.length - 4 &&
                state.hasMorePages &&
                !state.isLoadMoreLoading &&
                !state.isInitialLoading;

            if (shouldLoadMore) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final cubit = context.read<TestInteractionUsersCubit>();

                if (!cubit.state.isLoadMoreLoading &&
                    cubit.state.hasMorePages) {
                  cubit.loadMoreUsers(testId: testId, type: type);
                }
              });
            }

            final user = state.users[index];

            final isThisFollowLoading =
                state.isFollowLoading &&
                state.activeFollowUserId == user.userId;

            return Column(
              children: [
                InteractionUserTile(
                  userName: user.name,
                  avatarUrl: user.avatarUrl,
                  educationLevel: user.educationLevel,
                  isVerified: user.isAcademicallyVerified,
                  isFollowing: user.viewerIsFollowing,
                  isFollowLoading: isThisFollowLoading,
                  onFollowTap: () {
                    context.read<TestInteractionUsersCubit>().toggleFollowUser(
                      userId: user.userId,
                    );
                  },
                ),
                CustomDivider(height: 10, thickness: 1),
              ],
            );
          },
        );
      },
    );
  }
}

class InteractionUserTile extends StatelessWidget {
  final String userName;
  final String avatarUrl;
  final String educationLevel;
  final bool isVerified;
  final bool isFollowing;
  final bool isFollowLoading;
  final VoidCallback onFollowTap;

  const InteractionUserTile({
    super.key,
    required this.userName,
    required this.avatarUrl,
    required this.educationLevel,
    required this.isVerified,
    required this.isFollowing,
    required this.isFollowLoading,
    required this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        //horizontal: SizeConfig.w(0.03),
        vertical: SizeConfig.h(0.012),
      ),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : AppPalette.white,
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(
        //   color: isDark
        //       ? AppPalette.borderFieldColorNDark
        //       : AppPalette.greyBorderCart,
        // ),
        // boxShadow: [
        //   if (!isDark)
        //     BoxShadow(
        //       color: AppPalette.greyBorderCart.withOpacity(0.35),
        //       blurRadius: 8,
        //       offset: const Offset(0, 3),
        //     ),
        // ],
      ),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          _FollowButton(
            isFollowing: isFollowing,
            isLoading: isFollowLoading,
            onTap: onFollowTap,
          ),

          SizedBox(width: SizeConfig.w(0.03)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: CustomTextWidget(
                        userName,
                        color: appColors.blackToGrey2Dark,
                        fontFamily: AppFont.elMessiriSemiBold,
                        fontSize: SizeConfig.text(0.034),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                    ),

                    if (isVerified) ...[
                      SizedBox(width: SizeConfig.w(0.01)),
                      Icon(
                        Icons.verified_rounded,
                        color: appColors.primaryToPrimaryDark,
                        size: SizeConfig.text(0.04),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: SizeConfig.h(0.004)),
                CustomBackgroundWithChild(
                  childHorizontalPad: SizeConfig.w(0.015),
                  childVerticalPad: SizeConfig.h(0.005),
                  borderRadius: BorderRadius.circular(5),
                  backgroundColor: appColors.primarySoftTogreyLightDark,
                  child: CustomTextWidget(
                    educationLevel,
                    color: appColors.primaryToPrimaryDark,
                    fontFamily: AppFont.elMessiriRegular,
                    fontSize: SizeConfig.text(0.025),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: SizeConfig.w(0.03)),

          _UserAvatar(avatarUrl: avatarUrl),
        ],
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String avatarUrl;

  const _UserAvatar({required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: SizeConfig.w(0.065),

      backgroundColor: AppPalette.grey,
      child: CustomAppImage(
        path: avatarUrl,
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  final bool isFollowing;
  final bool isLoading;
  final VoidCallback onTap;

  const _FollowButton({
    required this.isFollowing,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomButtonWidget(
      backgroundColor: isFollowing
          ? appColors.greyMediumTogrey
          : appColors.primaryToPrimaryDark,
      borderRadius: 18,
      childHorizontalPad: SizeConfig.w(0.035),
      childVerticalPad: SizeConfig.h(0.007),
      onTap: isLoading ? () {} : onTap,
      child: isLoading
          ? SizedBox(
              width: SizeConfig.w(0.035),
              height: SizeConfig.w(0.035),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppPalette.white,
              ),
            )
          : CustomTextWidget(
              isFollowing ? 'إلغاء المتابعة' : 'متابعة',
              color: isFollowing
                  ? appColors.whiteToblack
                  : appColors.whiteToblack,
              fontFamily: AppFont.elMessiriSemiBold,
              fontSize: SizeConfig.text(0.028),
            ),
    );
  }
}
