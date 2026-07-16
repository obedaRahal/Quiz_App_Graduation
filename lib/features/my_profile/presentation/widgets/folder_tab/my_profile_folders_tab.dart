import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_confirmation_dialog.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/my_profile_folder_editor_route_args.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_state.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/folder_tab/my_profile_folder_card.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/folder_tab/my_profile_folder_content_bottom_sheet.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/folder_tab/my_profile_folders_filter_section.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/shimmer/my_profile_folder_card_shimmer.dart';

class MyProfileFoldersTab extends StatelessWidget {
  final int userId;
  const MyProfileFoldersTab({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyProfileCubit, MyProfileState>(
      listenWhen: (previous, current) =>
          previous.deleteFolderStatus != current.deleteFolderStatus,
      listener: (context, state) {
        if (state.isDeleteFolderSuccess) {
          showValidationTopSnackBar(
            context,
            title: 'نجاح',
            message: state.folderActionMessage ?? 'تم حذف المجلد بنجاح',
            type: AppValidationSnackBarType.success,
          );

          context.read<MyProfileCubit>().resetDeleteMyProfileFolderState();
        }

        if (state.isDeleteFolderFailure) {
          showValidationTopSnackBar(
            context,
            title: state.errorTitle ?? 'خطأ',
            message: state.errorMessage ?? 'تعذر حذف المجلد',
            type: AppValidationSnackBarType.error,
          );

          context.read<MyProfileCubit>().resetDeleteMyProfileFolderState();
        }
      },
      buildWhen: (previous, current) =>
          previous.selectedFoldersTab != current.selectedFoldersTab ||
          previous.foldersStatus != current.foldersStatus ||
          previous.foldersResponse != current.foldersResponse ||
          previous.isFoldersLoadingMore != current.isFoldersLoadingMore ||
          previous.deleteFolderStatus != current.deleteFolderStatus ||
          previous.activeDeletingFolderId != current.activeDeletingFolderId,
      builder: (context, state) {
        final folders = state.foldersResponse?.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            MyProfileFoldersFilterSection(
              selectedFilter: state.selectedFoldersTab,
              onFilterSelected: context
                  .read<MyProfileCubit>()
                  .changeMyProfileFoldersTab,
            ),

            SizedBox(height: SizeConfig.h(0.018)),

            if (state.isFoldersLoading)
              const MyProfileFoldersShimmerList()
            else if (state.isFoldersFailure)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.05)),
                  child: CustomTextWidget(
                    state.errorMessage ?? 'حدث خطأ أثناء جلب المجلدات',
                    color: AppPalette.red,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else if (folders.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.05)),
                  child: const Text(
                    'لا توجد مجلدات ضمن هذا التصنيف الحالي',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              Column(
                children: [
                  ...folders.map((folder) {
                    return Column(
                      children: [
                        MyProfileFolderCard(
                          folder: folder,

                          onEditTap: () async {
                            debugPrint('edit folder: ${folder.id}');

                            final result = await context.pushNamed(
                              AppRouterName.myProfileFolderEditor,
                              extra: MyProfileFolderEditorRouteArgs.edit(
                                folder: folder,
                                userId: userId,
                              ),
                            );

                            if (result == true && context.mounted) {
                              context
                                  .read<MyProfileCubit>()
                                  .fetchMyProfileFoldersInitial();
                            }
                          },
                          onDeleteTap: () {
                            debugPrint('delete folder: ${folder.id}');
                            if (state.isDeletingFolder(folder.id)) {
                              return;
                            }

                            showCustomConfirmationDialog(
                              context: context,

                              title: 'حذف المجلد',
                              message:
                                  'هل أنت متأكد من حذف "${folder.name}"؟\n'
                                  'سيتم حذف المجلد، لكن لن يتم حذف الاختبارات الموجودة داخله.',
                              confirmText: 'حذف',
                              cancelText: 'إلغاء',
                              icon: Icons.delete,
                              iconColor: AppPalette.red,
                              iconBackgroundColor: AppPalette.red.withOpacity(
                                0.09,
                              ),
                              confirmBackgroundColor: AppPalette.red,

                              onConfirm: () {
                                context
                                    .read<MyProfileCubit>()
                                    .deleteMyProfileFolder(folderId: folder.id);
                              },
                            );
                          },
                          onFolderTap: () {
                            debugPrint('folder tap: ${folder.id}');
                            showMyProfileFolderContentBottomSheet(
                              context: context,
                              folder: folder,
                            );
                          },
                        ),
                        const CustomDivider(height: 10, thickness: 2),
                      ],
                    );
                  }),

                  if (state.isFoldersLoadingMore)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.h(0.018),
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}
