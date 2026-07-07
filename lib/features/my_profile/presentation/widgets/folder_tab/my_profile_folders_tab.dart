import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_state.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/folder_tab/my_profile_folder_card.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/folder_tab/my_profile_folders_filter_section.dart';

class MyProfileFoldersTab extends StatelessWidget {
  const MyProfileFoldersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
      buildWhen: (previous, current) =>
          previous.selectedFoldersTab != current.selectedFoldersTab ||
          previous.foldersStatus != current.foldersStatus ||
          previous.foldersResponse != current.foldersResponse ||
          previous.isFoldersLoadingMore != current.isFoldersLoadingMore,
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
              const Center(child: CircularProgressIndicator())
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
                          onMoreTap: () {
                            debugPrint('folder more: ${folder.id}');
                          },
                          onFolderTap: () {
                            debugPrint('folder tap: ${folder.id}');
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
