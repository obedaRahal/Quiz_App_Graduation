import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/notification/domain/entities/notification_entity.dart';
import 'package:quiz_app_grad/features/notification/presentation/manager/notification/notification_cubit.dart';
import 'package:quiz_app_grad/features/notification/presentation/manager/notification/notification_state.dart';
import 'package:quiz_app_grad/features/notification/presentation/navigation/notification_navigation_resolver.dart';
import 'package:quiz_app_grad/features/notification/presentation/widgets/notification_card.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return BlocProvider<NotificationCubit>(
      create: (_) => sl<NotificationCubit>()..fetchInitial(),
      child: const _NotificationBody(),
    );
  }
}

class _NotificationBody extends StatefulWidget {
  const _NotificationBody();

  @override
  State<_NotificationBody> createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<_NotificationBody> {
  static const _navigationResolver = NotificationNavigationResolver();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    if (position.maxScrollExtent <= 0) {
      return;
    }

    if (position.pixels >= position.maxScrollExtent * 0.8) {
      context.read<NotificationCubit>().fetchMoreIfNeeded();
    }
  }

  void _navigateToNotificationPage(NotificationEntity notification) {
    final decision = _navigationResolver.resolve(notification);

    if (decision.canNavigate) {
      context.pushNamed(decision.routeName!, extra: decision.extra);
      return;
    }

    showValidationTopSnackBar(
      context,
      title: decision.isBlocked ? 'الاختبار غير متاح' : 'تعذر فتح الوجهة',
      message: decision.message ?? 'تعذر فتح الوجهة المرتبطة بهذا الإشعار.',
      type: decision.isBlocked
          ? AppValidationSnackBarType.hint
          : AppValidationSnackBarType.error,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);

    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopPageHeader(
              title: 'الإشعارات',
              onBack: () {
                Navigator.of(context).pop();
              },
              icon: Icons.search,
              onIconTap: () {
                context.pushNamed(AppRouterName.search);
              },
            ),

            Expanded(
              child: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.hasError && state.notifications.isEmpty) {
                    return _NotificationFailureBody(
                      message: state.errorMessage ?? 'تعذر جلب الإشعارات',
                      onRetry: () {
                        context.read<NotificationCubit>().fetchInitial();
                      },
                    );
                  }

                  if (state.notifications.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () {
                        return context.read<NotificationCubit>().refresh();
                      },
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: SizeConfig.h(0.3)),
                          Center(
                            child: CustomTextWidget(
                              'لا توجد إشعارات حالياً',
                              color: AppPalette.greyMedium,
                              fontSize: SizeConfig.text(0.035),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () {
                      return context.read<NotificationCubit>().refresh();
                    },
                    child: ListView.separated(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.w(0.03),
                        vertical: SizeConfig.h(0.02),
                      ),
                      itemCount:
                          state.notifications.length +
                          (state.isLoadingMore ? 1 : 0),
                      separatorBuilder: (_, index) {
                        if (index >= state.notifications.length - 1) {
                          return const SizedBox.shrink();
                        }

                        return SizedBox(height: SizeConfig.h(0.012));
                      },
                      itemBuilder: (context, index) {
                        if (index >= state.notifications.length) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.h(0.018),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final notification = state.notifications[index];

                        return NotificationCard(
                          notification: notification,
                          navigateToPage: () =>
                              _navigateToNotificationPage(notification),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationFailureBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _NotificationFailureBody({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.w(0.05)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextWidget(
              message,
              color: AppPalette.greyMedium,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: SizeConfig.h(0.02)),

            TextButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
          ],
        ),
      ),
    );
  }
}
