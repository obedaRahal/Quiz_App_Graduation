import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/empty_action_box.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_folders_entity.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/shimmer/my_profile_folder_card_shimmer.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/folder_tab/other_profile_folder_card.dart';

class OtherProfileFoldersTab extends StatelessWidget {
  final List<OtherProfileFolderItemEntity> folders;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasLoadMoreError;
  final String? loadMoreErrorMessage;
  final Widget? shimmerLoader;
  final VoidCallback onLoadMore;
  final Function(int folderId) onSaveTap;
  final Function(int folderId) onFolderTap;

  const OtherProfileFoldersTab({
    super.key,
    required this.folders,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasLoadMoreError,
    required this.loadMoreErrorMessage,
    required this.onLoadMore,
    required this.onSaveTap,
    required this.onFolderTap,
    this.shimmerLoader,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: SizeConfig.h(0.018)),

        if (isLoading)
          shimmerLoader ?? const MyProfileFoldersShimmerList()
        else if (folders.isEmpty)
          const EmptyActionBox(
            icon: Icons.folder_open_outlined,
            title: 'لا توجد مجلدات',
            description: 'لا توجد مجلدات متاحة ضمن هذا التصنيف حالياً',
          )
        else
          Column(
            children: [
              ...folders.map((folder) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () => onFolderTap(folder.id),
                      child: OtherProfileFolderCard(
                        folder: folder,
                        onSaveTap: () => onSaveTap(folder.id),
                      ),
                    ),
                    CustomDivider(height: 10, thickness: 2),
                  ],
                );
              }),

              if (isLoadingMore)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.018)),
                  child: const Center(child: MyProfileFolderCardShimmer()),
                )
              else if (hasLoadMoreError)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.018)),
                  child: Column(
                    children: [
                      Text(
                        loadMoreErrorMessage ?? 'تعذر تحميل المزيد من المجلدات',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: onLoadMore,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
