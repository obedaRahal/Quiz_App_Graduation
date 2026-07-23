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

        const CustomDivider(height: 10, thickness: 1),

        Expanded(
          child: BlocConsumer<SearchCubit, SearchState>(
            listenWhen: (previous, current) {
              final searchErrorChanged =
                  previous.errorMessage != current.errorMessage &&
                  current.hasError;

              final followErrorChanged =
                  previous.followErrorMessage != current.followErrorMessage &&
                  current.hasFollowError;

              final historyErrorChanged =
                  previous.historyErrorMessage != current.historyErrorMessage &&
                  current.hasHistoryError;

              final historyActionErrorChanged =
                  previous.historyActionErrorMessage !=
                      current.historyActionErrorMessage &&
                  current.hasHistoryActionError;

              return searchErrorChanged ||
                  followErrorChanged ||
                  historyErrorChanged ||
                  historyActionErrorChanged;
            },
            listener: (context, state) {
              final cubit = context.read<SearchCubit>();

              if (state.hasFollowError) {
                showValidationTopSnackBar(
                  context,
                  title: state.followErrorTitle ?? 'خطأ',
                  message:
                      state.followErrorMessage ?? 'تعذر تنفيذ عملية المتابعة',
                  type: AppValidationSnackBarType.error,
                );

                cubit.clearFollowError();
                return;
              }

              if (state.hasHistoryActionError) {
                showValidationTopSnackBar(
                  context,
                  title: state.historyActionErrorTitle ?? 'خطأ',
                  message:
                      state.historyActionErrorMessage ??
                      'تعذر تنفيذ العملية على سجل البحث',
                  type: AppValidationSnackBarType.error,
                );

                cubit.clearHistoryActionError();
                return;
              }

              if (state.hasHistoryError) {
                showValidationTopSnackBar(
                  context,
                  title: state.historyErrorTitle ?? 'خطأ',
                  message: state.historyErrorMessage ?? 'تعذر جلب سجل البحث',
                  type: AppValidationSnackBarType.error,
                );

                cubit.clearHistoryError();
                return;
              }

              if (state.hasError) {
                showValidationTopSnackBar(
                  context,
                  title: state.errorTitle ?? 'خطأ',
                  message: state.errorMessage ?? 'تعذر إجراء البحث',
                  type: AppValidationSnackBarType.error,
                );

                cubit.clearSearchError();
              }
            },
            builder: (context, state) {
              if (!state.isSearching) {
                return _buildHistory(context, state);
              }

              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
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

Widget _buildHistory(BuildContext context, SearchState state) {
  final cubit = context.read<SearchCubit>();

  if (state.isHistoryLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  final histories = state.histories
      .map(
        (history) => SearchHistoryUiModel(id: history.id, query: history.query),
      )
      .toList();

  return SearchHistorySection(
    histories: histories,
    onHistoryTap: (history) {
      cubit.selectHistoryQuery(history.query);
    },
    onDeleteHistory: (history) {
      cubit.deleteSearchHistoryItem(historyId: history.id);
    },
    onClearAll: cubit.clearAllSearchHistory,
  );
}
