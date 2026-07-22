import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_connections_bottom_sheet.dart';
import 'package:quiz_app_grad/features/search/domain/entities/search_user_entity.dart';

class SearchResultsList extends StatelessWidget {
  final List<SearchUserEntity> users;
  final bool isLoadingMore;
  final bool hasMorePages;
  final String? loadMoreErrorMessage;
  final int? activeFollowUserId;
  final bool isFollowLoading;
  final ValueChanged<SearchUserEntity> onUserTap;
  final ValueChanged<SearchUserEntity> onFollowTap;
  final VoidCallback onLoadMore;
  final VoidCallback onRetryLoadMore;

  const SearchResultsList({
    super.key,
    required this.users,
    required this.isLoadingMore,
    required this.hasMorePages,
    required this.loadMoreErrorMessage,
    required this.activeFollowUserId,
    required this.isFollowLoading,
    required this.onUserTap,
    required this.onFollowTap,
    required this.onLoadMore,
    required this.onRetryLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return Center(
        child: CustomTextWidget(
          'لا توجد نتائج مطابقة',
          color: AppPalette.greyMedium,
          textAlign: TextAlign.center,
          fontSize: SizeConfig.text(0.034),
        ),
      );
    }

    final hasFooter = isLoadingMore || loadMoreErrorMessage != null;

    return ListView.separated(
      padding: EdgeInsets.symmetric(
        //horizontal: SizeConfig.w(0.045),
        vertical: SizeConfig.h(0.018),
      ),
      itemCount: users.length + (hasFooter ? 1 : 0),
      separatorBuilder: (_, __) {
        return CustomDivider(height: 10, thickness: 1);
      },
      itemBuilder: (context, index) {
        if (index >= users.length) {
          return _LoadMoreFooter(
            isLoading: isLoadingMore,
            errorMessage: loadMoreErrorMessage,
            onRetry: onRetryLoadMore,
          );
        }

        final shouldLoadMore =
            index >= users.length - 4 &&
            hasMorePages &&
            !isLoadingMore &&
            !hasFooter;

        if (shouldLoadMore) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onLoadMore();
          });
        }

        final user = users[index];

        final isThisFollowLoading =
            isFollowLoading && activeFollowUserId == user.id;

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onUserTap(user),
          child: OtherProfileConnectionUserTile(
            userName: user.name,
            avatarUrl: user.avatarUrl,
            educationLevel: user.academicLevel,
            isVerified: user.isAcademicallyVerified,
            isFollowing: user.viewerIsFollowing,
            isFollowLoading: isThisFollowLoading,
            onFollowTap: () => onFollowTap(user),
          ),
        );
      },
    );
  }
}

class _LoadMoreFooter extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;

  const _LoadMoreFooter({
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.018)),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.015)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextWidget(
            errorMessage ?? 'تعذر تحميل المزيد من النتائج',
            color: AppPalette.red,
            textAlign: TextAlign.center,
            fontSize: SizeConfig.text(0.032),
          ),
          TextButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
        ],
      ),
    );
  }
}
