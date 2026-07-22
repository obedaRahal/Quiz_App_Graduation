import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/data/models/other_profile_route_args.dart';
import 'package:quiz_app_grad/features/search/presentation/manager/search/search_cubit.dart';
import 'package:quiz_app_grad/features/search/presentation/manager/search/search_state.dart';
import 'package:quiz_app_grad/features/search/presentation/widgets/search_history_section.dart';
import 'package:quiz_app_grad/features/search/presentation/widgets/search_results_list.dart';
import 'package:quiz_app_grad/features/search/presentation/widgets/user_search_field.dart';

class SearchBody extends StatelessWidget {
  const SearchBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.018)),
          child: UserSearchField(
            controller: cubit.searchController,
            onChanged: cubit.onQueryChanged,
          ),
        ),

        CustomDivider(height: 10, thickness: 1),

        Expanded(
          child: BlocConsumer<SearchCubit, SearchState>(
            listenWhen: (previous, current) =>
                previous.followErrorMessage != current.followErrorMessage &&
                current.hasFollowError,
            listener: (context, state) {
              showValidationTopSnackBar(
                context,
                title: state.followErrorTitle ?? 'خطأ',
                message:
                    state.followErrorMessage ?? 'تعذر تنفيذ عملية المتابعة',
                type: AppValidationSnackBarType.error,
              );

              context.read<SearchCubit>().clearFollowError();
            },
            builder: (context, state) {
              if (!state.isSearching) {
                return _buildHistory(context);
              }

              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.hasError && state.users.isEmpty) {
                return Center(
                  child: CustomTextWidget(
                    state.errorMessage ?? 'تعذر إجراء البحث',
                    color: AppPalette.red,
                    textAlign: TextAlign.center,
                    fontSize: SizeConfig.text(0.034),
                  ),
                );
              }

              return SearchResultsList(
                users: state.users,
                isLoadingMore: state.isLoadingMore,
                hasMorePages: state.hasMorePages,
                loadMoreErrorMessage: state.loadMoreErrorMessage,
                activeFollowUserId: state.activeFollowUserId,
                isFollowLoading: state.isFollowLoading,
                onUserTap: (user) {
                  context.pushNamed(
                    AppRouterName.otherProfile,
                    extra: OtherProfileRouteArgs(userId: user.id),
                  );
                },
                onFollowTap: (user) {
                  cubit.toggleFollowUser(userId: user.id);
                },
                onLoadMore: cubit.fetchMoreIfNeeded,
                onRetryLoadMore: cubit.fetchMoreIfNeeded,
              );
            },
          ),
        ),
      ],
    );
  }
}

Widget _buildHistory(BuildContext context) {
  final cubit = context.read<SearchCubit>();

  return SearchHistorySection(
    histories: const [
      SearchHistoryUiModel(id: 1, query: 'نور'),
      SearchHistoryUiModel(id: 2, query: 'عبد الهادي'),
    ],
    onHistoryTap: (history) {
      cubit.selectHistoryQuery(history.query);
    },
    onDeleteHistory: (_) {},
    onClearAll: () {},
  );
}
