import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_cubit.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/content_tab/other_profile_content_tab.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/list_tab/other_profile_lists_tab.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_header_card.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/overview_tab/other_profile_overview_tab.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_tabs_section.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/test_tab/other_profile_tests_tab.dart';

class OtherProfileBody extends StatelessWidget {
  final int userId;

  const OtherProfileBody({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherProfileCubit, OtherProfileState>(
      buildWhen: (previous, current) =>
          previous.profile != current.profile ||
          previous.selectedTab != current.selectedTab,
      builder: (context, state) {
        final profile = state.profile;

        if (profile == null) {
          return const SizedBox.shrink();
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.h(0.012)),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
                child: OtherProfileHeaderCard(
                  profile: profile,
                  onFollowTap: () {
                    context.read<OtherProfileCubit>().toggleFollowLocally();
                  },
                ),
              ),

              SizedBox(height: SizeConfig.h(0.018)),

              OtherProfileTabsSection(
                selectedTab: state.selectedTab,
                onTabSelected: (tab) {
                  context.read<OtherProfileCubit>().changeSelectedTab(tab);
                },
              ),

              SizedBox(height: SizeConfig.h(0.018)),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
                child: _OtherProfileSelectedTabContent(
                  selectedTab: state.selectedTab,
                  profile: profile,
                ),
              ),

              SizedBox(height: SizeConfig.h(0.03)),
            ],
          ),
        );
      },
    );
  }
}

class _OtherProfileSelectedTabContent extends StatelessWidget {
  final OtherProfileTab selectedTab;
  final OtherProfileUiModel profile;

  const _OtherProfileSelectedTabContent({
    required this.selectedTab,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedTab) {
      case OtherProfileTab.overview:
        return const OtherProfileOverviewTab();

      case OtherProfileTab.tests:
        return const OtherProfileTestsTab();

      case OtherProfileTab.lists:
        return const OtherProfileListsTab();

      case OtherProfileTab.content:
        return const OtherProfileContentTab();
    }
  }
}
