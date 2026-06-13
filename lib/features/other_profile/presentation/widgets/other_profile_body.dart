import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_overview_entity.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_cubit.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/content_tab/other_profile_content_tab.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/list_tab/other_profile_lists_tab.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_header_card.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/overview_tab/other_profile_overview_tab.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_tabs_section.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/test_tab/other_profile_tests_tab.dart';

class OtherProfileBody extends StatefulWidget {
  final int userId;

  const OtherProfileBody({super.key, required this.userId});

  @override
  State<OtherProfileBody> createState() => _OtherProfileBodyState();
}

class _OtherProfileBodyState extends State<OtherProfileBody> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<OtherProfileCubit>().getOtherProfileOverview(
        userId: widget.userId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherProfileCubit, OtherProfileState>(
      buildWhen: (previous, current) =>
          previous.profile != current.profile ||
          previous.selectedTab != current.selectedTab ||
          previous.overview != current.overview ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        if (state.isFetchOverviewLoading) {
          return const Center(
            child:
                CircularProgressIndicator(), // أو يمكنك استبداله بالـ Shimmer المعتمد بمشروعك
          );
        }

        // 2. حالة الفشل (Failure)
        if (state.isFetchOverviewFailure) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.w(0.05)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
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
                    color: Colors.grey,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final overviewEntity = state.overview;
        if (overviewEntity == null) {
          return const SizedBox.shrink();
        }

        final data = overviewEntity.data;

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
                  profile: data.header,
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
                  //profile: profile,
                  dataEntity: data, // تمرير كائن البيانات العام للتابات
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
  final OtherProfileOverviewDataEntity dataEntity;

  const _OtherProfileSelectedTabContent({
    required this.selectedTab,
    required this.dataEntity,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedTab) {
      case OtherProfileTab.overview:
        return OtherProfileOverviewTab(dataEntity: dataEntity);

      case OtherProfileTab.tests:
        return const OtherProfileTestsTab();

      case OtherProfileTab.lists:
        return const OtherProfileListsTab();

      case OtherProfileTab.content:
        return const OtherProfileContentTab();
    }
  }
}
