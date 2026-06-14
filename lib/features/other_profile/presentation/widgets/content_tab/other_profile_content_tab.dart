import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_content_entity.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/content_tab/other_profile_content_card.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/content_tab/other_profile_content_filter_section.dart';
class OtherProfileContentTab extends StatelessWidget {
  final OtherProfileContentFilter selectedFilter;
  final ValueChanged<OtherProfileContentFilter> onFilterSelected;
  final List<OtherProfileContentItemEntity> contents;
  final bool isLoading;
  final bool isLoadingMore;
  final void Function(int contentId) onSaveTap;
  final void Function(int contentId) onLikeTap;
  final Widget? shimmerLoader;

  const OtherProfileContentTab({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.contents,
    required this.isLoading,
    required this.isLoadingMore,
    required this.onSaveTap,
    required this.onLikeTap,
    this.shimmerLoader,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        OtherProfileContentFilterSection(
          selectedFilter: selectedFilter,
          onFilterSelected: onFilterSelected,
        ),

        SizedBox(height: SizeConfig.h(0.018)),

        if (isLoading)
          shimmerLoader ?? const Center(child: CircularProgressIndicator())
        else if (contents.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.05)),
              child: const Text(
                'لا يوجد محتوى متاح ضمن هذا التصنيف الحالي',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          Column(
            children: [
              ...contents.map((content) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: SizeConfig.h(0.012)),
                      child: OtherProfileContentCard(
                        content: content,
                        onSaveTap: () => onSaveTap(content.id),
                        onLikeTap: () => onLikeTap(content.id),
                      ),
                    ),
                    CustomDivider(height: 10, thickness: 2),
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