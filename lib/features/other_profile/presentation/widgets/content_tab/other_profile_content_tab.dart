import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_cubit.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/content_tab/other_profile_content_card.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/content_tab/other_profile_content_filter_section.dart';

class OtherProfileContentTab extends StatelessWidget {
  const OtherProfileContentTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherProfileCubit, OtherProfileState>(
      buildWhen: (previous, current) =>
          previous.selectedContentFilter != current.selectedContentFilter ||
          previous.contents != current.contents,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            OtherProfileContentFilterSection(
              selectedFilter: state.selectedContentFilter,
              onFilterSelected: context
                  .read<OtherProfileCubit>()
                  .changeSelectedContentFilter,
            ),

            SizedBox(height: SizeConfig.h(0.018)),

            Column(
              children: state.contents.map((content) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: SizeConfig.h(0.012)),
                      child: OtherProfileContentCard(
                        content: content,
                        onSaveTap: () {
                          context
                              .read<OtherProfileCubit>()
                              .toggleContentSaveLocally(contentId: content.id);
                        },
                        onLikeTap: () {
                          context
                              .read<OtherProfileCubit>()
                              .toggleContentLikeLocally(contentId: content.id);
                        },
                      ),
                    ),
                    CustomDivider(height: 10, thickness: 2),
                  ],
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
