// lib/features/my_profile/presentation/widgets/content_tab/my_profile_content_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_state.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/mappers/my_profile_library_mapper.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/content_tab/my_profile_content_filter_section.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/content_tab/my_profile_content_search_field.dart';
import 'package:quiz_app_grad/features/content_details/presentation/route_args/content_details_route_args.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/shimmer/other_profile_content_card_shimmer.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/content_tab/other_profile_content_card.dart';

class MyProfileContentTab extends StatefulWidget {
  const MyProfileContentTab({super.key});

  @override
  State<MyProfileContentTab> createState() => _MyProfileContentTabState();
}

class _MyProfileContentTabState extends State<MyProfileContentTab> {
  @override
  void initState() {
    super.initState();

    // Future.microtask(() {
    //   if (!mounted) return;
    //   context.read<MyProfileCubit>().fetchMyProfileLibraryInitial();
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
      buildWhen: (previous, current) =>
          previous.selectedLibraryTab != current.selectedLibraryTab ||
          previous.libraryStatus != current.libraryStatus ||
          previous.libraryResponse != current.libraryResponse ||
          previous.isLibraryLoadingMore != current.isLibraryLoadingMore ||
          previous.librarySearchText != current.librarySearchText,
      builder: (context, state) {
        final items = state.libraryResponse?.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            MyProfileContentSearchField(
              value: state.librarySearchText,
              onChanged: context
                  .read<MyProfileCubit>()
                  .changeMyProfileLibrarySearchText,
              onClear: context
                  .read<MyProfileCubit>()
                  .clearMyProfileLibrarySearch,
            ),

            SizedBox(height: SizeConfig.h(0.014)),

            MyProfileContentFilterSection(
              selectedTab: state.selectedLibraryTab,
              onTabSelected: context
                  .read<MyProfileCubit>()
                  .changeMyProfileLibraryTab,
            ),

            SizedBox(height: SizeConfig.h(0.018)),

            if (state.isLibraryLoading)
              ContentCardsShimmerList()
            else if (state.libraryStatus == FetchMyProfileStatus.failure)
              Padding(
                padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.06)),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextWidget(
                        state.libraryError?.message ?? 'تعذر جلب المحتوى',
                        color: AppPalette.greyMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: SizeConfig.h(0.014)),
                      ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<MyProfileCubit>()
                              .retryMyProfileLibraryInitial();
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              )
            else if (items.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.06)),
                child: Center(
                  child: CustomTextWidget(
                    'لا يوجد محتوى لعرضه حالياً',
                    color: AppPalette.greyMedium,
                    fontSize: SizeConfig.text(0.034),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    items.length +
                    (state.isLibraryLoadingMore || state.libraryError != null
                        ? 1
                        : 0),
                itemBuilder: (context, index) {
                  if (index >= items.length) {
                    if (state.isLibraryLoadingMore) {
                      return OtherProfileContentCardShimmer();
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.h(0.014),
                      ),
                      child: Column(
                        children: [
                          CustomTextWidget(
                            state.libraryError?.message ??
                                'تعذر تحميل المزيد من المحتوى',
                            color: AppPalette.red,
                            textAlign: TextAlign.center,
                          ),
                          TextButton.icon(
                            onPressed: () {
                              final cubit = context.read<MyProfileCubit>();
                              if (state.librarySearchText.trim().isEmpty) {
                                cubit.fetchMoreMyProfileLibraryIfNeeded();
                              } else {
                                cubit.fetchMoreMyProfileLibrarySearchIfNeeded();
                              }
                            },
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  }

                  final item = items[index];

                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: SizeConfig.h(0.014)),
                        child: OtherProfileContentCard(
                          content: item.toOtherProfileContentEntity(),
                          showSaveButton: false,
                          showLikeButton: false,
                          onContentTap: () {
                            context.pushNamed(
                              AppRouterName.otherContentDetails,
                              extra: ContentDetailsRouteArgs(
                                contentId: item.id,
                                isMyContent: true,
                                isMyPublicContent: _isPublicContent(
                                  item.libraryMaterialKind,
                                  state.selectedLibraryTab,
                                ),
                              ),
                            );
                          },
                          // لا توجد عمليتا حفظ أو إعجاب ضمن تبويب «محتواي».
                          onSaveTap: () {},
                          onLikeTap: () {},
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        );
      },
    );
  }

  bool _isPublicContent(String materialKind, MyProfileLibraryTab selectedTab) {
    final normalized = materialKind.trim().toLowerCase();

    if (normalized.contains('private') || normalized.contains('خاص')) {
      return false;
    }

    if (normalized.contains('public') || normalized.contains('عام')) {
      return true;
    }

    return selectedTab != MyProfileLibraryTab.private;
  }
}
