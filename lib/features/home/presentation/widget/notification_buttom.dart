import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/features/notification/presentation/manager/notification_unread_count/notification_unread_count_cubit.dart';
import 'package:quiz_app_grad/features/notification/presentation/manager/notification_unread_count/notification_unread_count_state.dart';

class NotificationButton extends StatelessWidget {
  final bool isDark;

  const NotificationButton({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      NotificationUnreadCountCubit,
      NotificationUnreadCountState
    >(
      buildWhen: (previous, current) {
        return previous.unreadCount != current.unreadCount ||
            previous.hasUnread != current.hasUnread;
      },
      builder: (context, state) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppPalette.borderFieldColorNDark
                    : AppPalette.primaryToWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(5.5),
              child: Icon(
                Icons.notifications_outlined,
                color: isDark ? AppPalette.textWhiteINDark : AppPalette.black,
              ),
            ),

            if (state.hasUnread && state.unreadCount > 0)
              Positioned(
                top: -7,
                right: -7,
                child: _NotificationCountBadge(count: state.unreadCount),
              ),
          ],
        );
      },
    );
  }
}

class _NotificationCountBadge extends StatelessWidget {
  final int count;

  const _NotificationCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final displayedCount = count > 99 ? '99+' : count.toString();

    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: 1.5,
        ),
      ),
      child: Text(
        displayedCount,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
      ),
    );
  }
}
