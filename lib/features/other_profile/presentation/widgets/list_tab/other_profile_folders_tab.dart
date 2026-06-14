import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_folders_entity.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/list_tab/other_profile_folder_card.dart';

class OtherProfileFoldersTab extends StatelessWidget {
  final List<OtherProfileFolderItemEntity> folders;
  final bool isLoading;
  final bool isLoadingMore;
  final Widget? shimmerLoader;
  final VoidCallback onLoadMore;
  final Function(int folderId) onSaveTap;

  const OtherProfileFoldersTab({
    super.key,
    required this.folders,
    required this.isLoading,
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.onSaveTap,
    this.shimmerLoader,
  });

  @override
  Widget build(BuildContext context) {
    Color parseHexColor(
      String value, {
      Color fallback = Colors.transparent,
    }) {
      var hex = value.trim();

      if (hex.isEmpty) return fallback;

      if (hex.startsWith('#')) {
        hex = hex.substring(1);
      }

      if (hex.length == 6) {
        hex = 'FF$hex';
      }

      if (hex.length != 8) {
        return fallback;
      }

      final colorValue = int.tryParse(hex, radix: 16);
      if (colorValue == null) return fallback;

      return Color(colorValue);
    }

    // OtherProfileFolderUiModel mapFolder(OtherProfileFolderItemEntity e) {
    //   return OtherProfileFolderUiModel(
    //     id: e.id,
    //     title: e.name,
    //     testsCount: e.testsCount,
    //     createdAt: e.publishedAt,
    //     color: parseHexColor(e.colorCode),
    //     isSaved: e.viewerHasBookmarked,
    //     tags: e.scientificInterests,
    //   );
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: SizeConfig.h(0.018)),

        if (isLoading)
          shimmerLoader ?? const Center(child: CircularProgressIndicator())
        else if (folders.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.05)),
              child: const Text(
                'لا توجد قوائم متاحة ضمن هذا التصنيف الحالي',
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
                    OtherProfileFolderCard(
                      folder: folder,
                      onSaveTap: () => onSaveTap(folder.id),
                    ),
                    CustomDivider(height: 10, thickness: 2)
                  ],
                );
              }),

              if (isLoadingMore)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.018)),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
      ],
    );
  }
}
