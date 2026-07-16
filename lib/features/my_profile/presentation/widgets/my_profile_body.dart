import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_confirmation_dialog.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/services/file_picker/core/services/file_picker_service.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_state.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/my_profile_header_card.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/my_profile_image_action_menu.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/my_profile_image_view_dialog.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/my_profile_selected_tab_content.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/my_profile_tabs_section.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/show_profile_image_preview_dialog.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_connections_type.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_connections/other_profile_connections_cubit.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/shimmer/other_profile_body_shimmer.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_connections_bottom_sheet.dart';

class MyProfileBody extends StatelessWidget {
  final int userId;
  const MyProfileBody({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyProfileCubit, MyProfileState>(
      listenWhen: (previous, current) =>
          previous.updateStatus != current.updateStatus,
      listener: (context, state) {
        if (state.isUpdateSuccess) {
          showValidationTopSnackBar(
            context,
            title: 'تم الحفظ',
            message: 'تم تحديث بيانات الملف الشخصي بنجاح',
            type: AppValidationSnackBarType.success,
          );

          context.read<MyProfileCubit>().resetUpdateState();
        }

        if (state.isUpdateFailure) {
          showValidationTopSnackBar(
            context,
            title: state.errorTitle ?? 'خطأ',
            message: state.errorMessage ?? 'تعذر حفظ التعديلات',
            type: AppValidationSnackBarType.error,
          );

          context.read<MyProfileCubit>().resetUpdateState();
        }
      },
      builder: (context, state) {
        if (state.isFetchLoading) {
          return const OtherProfileBodyShimmer();
        }

        if (state.isFetchFailure) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.w(0.05)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppPalette.red,
                    size: SizeConfig.w(0.12),
                  ),
                  SizedBox(height: SizeConfig.h(0.02)),
                  CustomTextWidget(
                    state.errorTitle ?? 'حدث خطأ غير متوقع',
                    fontFamily: AppFont.elMessiriBold,
                    fontSize: SizeConfig.text(0.045),
                  ),
                  SizedBox(height: SizeConfig.h(0.01)),
                  CustomTextWidget(
                    state.errorMessage ??
                        'يرجى التحقق من الاتصال والمحاولة مرة أخرى',
                    color: AppPalette.greyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final profile = state.editableProfile;

        if (profile == null) {
          return const SizedBox.shrink();
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            final metrics = notification.metrics;

            if (metrics.maxScrollExtent <= 0) return false;

            final scrollRatio = metrics.pixels / metrics.maxScrollExtent;

            if (scrollRatio < 0.8) return false;

            final cubit = context.read<MyProfileCubit>();

            if (state.selectedTab == MyProfileTab.content &&
                state.libraryResponse?.meta.hasMorePages == true &&
                !state.isLibraryLoadingMore &&
                !state.isLibraryLoading) {
              cubit.fetchMoreMyProfileLibraryIfNeeded();
            }

            if (state.selectedTab == MyProfileTab.content &&
                state.libraryResponse?.meta.hasMorePages == true &&
                !state.isLibraryLoadingMore &&
                !state.isLibraryLoading) {
              if (state.librarySearchText.trim().isEmpty) {
                cubit.fetchMoreMyProfileLibraryIfNeeded();
              } else {
                cubit.fetchMoreMyProfileLibrarySearchIfNeeded();
              }
            }

            if (state.selectedTab == MyProfileTab.folders &&
                state.hasMoreFoldersPages &&
                !state.isFoldersLoadingMore &&
                !state.isFoldersLoading) {
              cubit.fetchMoreMyProfileFoldersIfNeeded();
            }

            if (state.selectedTab == MyProfileTab.tests &&
                !state.isVisibleTestsLoading &&
                !state.isVisibleTestsLoadingMore) {
              if (state.hasTestsSearchQuery) {
                cubit.fetchMoreMyProfileTestsSearchIfNeeded();
              } else if (state.hasMoreTestsPages) {
                cubit.fetchMoreMyProfileTestsIfNeeded();
              }
            }

            if (state.selectedTab == MyProfileTab.tests) {
              if (state.isTestsFilterMode &&
                  !state.isTestsFilterLoading &&
                  !state.isTestsFilterLoadingMore &&
                  state.hasMoreFilteredTestsPages) {
                cubit.fetchMoreMyProfileFilteredTestsIfNeeded();
              } else if (state.hasTestsSearchQuery &&
                  !state.isTestsSearchLoading &&
                  !state.isTestsSearchLoadingMore) {
                cubit.fetchMoreMyProfileTestsSearchIfNeeded();
              } else if (!state.hasTestsSearchQuery &&
                  !state.isTestsLoading &&
                  !state.isTestsLoadingMore &&
                  state.hasMoreTestsPages) {
                cubit.fetchMoreMyProfileTestsIfNeeded();
              }
            }

            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.h(0.012)),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
                  child: MyProfileHeaderCard(
                    profile: profile,
                    onChangeCoverTap: () {
                      debugPrint("change cover");
                      showMyProfileImageActionMenu(
                        context: context,
                        title: 'اختر خيارًا لتغيير صورة الغلاف الخاصة بك',
                        hasCurrentImage: profile.coverUrl.trim().isNotEmpty,
                        onCamera: () {
                          _pickAndPreviewProfileImage(
                            context: context,
                            type: 'cover',
                            fromCamera: true,
                          );
                        },
                        onGallery: () {
                          _pickAndPreviewProfileImage(
                            context: context,
                            type: 'cover',
                            fromCamera: false,
                          );
                        },
                        onDelete: () {
                          showCustomConfirmationDialog(
                            context: context,
                            title: 'حذف صورة الغلاف؟',
                            message: 'هل أنت متأكد من حذف صورة الغلاف الحالية؟',
                            icon: Icons.delete_outline_rounded,
                            confirmText: 'حذف',
                            cancelText: 'إلغاء',
                            onConfirm: () async {
                              await context
                                  .read<MyProfileCubit>()
                                  .deleteMyProfilePicture(type: 'cover');
                            },
                          );
                        },
                        
                        onView: () {
                          debugPrint('cover view');
                          showMyProfileImageViewer(
                            context: context,
                            imageUrl: profile.coverUrl,
                          );
                        },
                      );
                    },
                    onChangeAvatarTap: () {
                      debugPrint("change avatar");
                      showMyProfileImageActionMenu(
                        context: context,
                        title: 'اختر خيارًا لتغيير الصورة الخاصة بك',
                        hasCurrentImage: profile.avatarUrl.trim().isNotEmpty,
                        onCamera: () {
                          _pickAndPreviewProfileImage(
                            context: context,
                            type: 'avatar',
                            fromCamera: true,
                          );
                        },
                        onGallery: () {
                          _pickAndPreviewProfileImage(
                            context: context,
                            type: 'avatar',
                            fromCamera: false,
                          );
                        },
                        onDelete: () {
                          showCustomConfirmationDialog(
                            context: context,
                            title: 'حذف الصورة الشخصية؟',
                            message:
                                'هل أنت متأكد من حذف الصورة الشخصية الحالية؟',
                            icon: Icons.delete_outline_rounded,
                            confirmText: 'حذف',
                            cancelText: 'إلغاء',
                            onConfirm: () async {
                              //Navigator.pop(context);

                              await context
                                  .read<MyProfileCubit>()
                                  .deleteMyProfilePicture(type: 'avatar');
                            },
                          );
                        },
                        onView: () {
                          debugPrint('avatar view');
                          showMyProfileImageViewer(
                            context: context,
                            imageUrl: profile.avatarUrl,
                          );
                        },
                      );
                    },
                    onShareTap: state.isShareLinkLoading
                        ? null
                        : () {
                            context
                                .read<MyProfileCubit>()
                                .getMyProfileShareLink();
                          },
                    onShowSavedTap: () {
                      debugPrint("show saved list");
                      context.pushNamed(AppRouterName.myProfileBookmarks);
                    },
                    onFollowersTap: () {
                      debugPrint("show followers ${profile.followersCount}");

                      showOtherProfileConnectionsBottomSheet(
                        context: context,
                        userId: profile.userId,
                        cubit: sl<OtherProfileConnectionsCubit>(),
                        type: OtherProfileConnectionsType.followers,
                        title: 'المتابعون',
                      );
                    },
                    onFollowingTap: () {
                      debugPrint("show following ${profile.followingCount}");
                      showOtherProfileConnectionsBottomSheet(
                        context: context,
                        userId: profile.userId,
                        cubit: sl<OtherProfileConnectionsCubit>(),
                        type: OtherProfileConnectionsType.following,
                        title: 'يتابعهم',
                      );
                    },
                  ),
                ),

                SizedBox(height: SizeConfig.h(0.018)),

                MyProfileTabsSection(
                  selectedTab: state.selectedTab,
                  onTabSelected: (tab) {
                    context.read<MyProfileCubit>().changeSelectedTab(tab);
                  },
                ),

                SizedBox(height: SizeConfig.h(0.018)),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
                  child: MyProfileSelectedTabContent(
                    selectedTab: state.selectedTab,
                    profile: profile,
                    userId: userId,
                  ),
                ),

                SizedBox(height: SizeConfig.h(0.03)),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickAndPreviewProfileImage({
    required BuildContext context,
    required String type, // avatar / cover
    required bool fromCamera,
  }) async {
    final picker = sl<FilePickerService>();

    final path = fromCamera
        ? await picker.captureImagePath()
        : await picker.pickSingleImagePath();

    if (path == null || !context.mounted) return;

    await showMyProfileImagePreviewDialog(
      context: context,
      imagePath: path,
      onSubmit: () async {
        return context.read<MyProfileCubit>().editMyProfilePicture(
          type: type,
          imagePath: path,
        );
      },
      onChangeImage: () {
        Navigator.pop(context);
        _pickAndPreviewProfileImage(
          context: context,
          type: type,
          fromCamera: fromCamera,
        );
      },
    );
  }
}
