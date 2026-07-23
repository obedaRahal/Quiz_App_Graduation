import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/features/content_details/presentation/route_args/content_details_route_args.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/details_of_test_route_args.dart';
import 'package:quiz_app_grad/features/notification/domain/entities/notification_entity.dart';
import 'package:quiz_app_grad/features/notification/presentation/navigation/notification_navigation_resolver.dart';
import 'package:quiz_app_grad/features/other_profile/data/models/other_profile_route_args.dart';

void main() {
  const resolver = NotificationNavigationResolver();

  group('NotificationNavigationResolver', () {
    test('opens public test details for a purchased test', () {
      final decision = resolver.resolve(
        _notification(
          type: 'test_purchase',
          screen: 'public_test_details',
          params: {'test_id': 11},
        ),
      );

      expect(decision.routeName, AppRouterName.detailsOfTest);
      expect((decision.extra as DetailsOfTestRouteArgs).testId, 11);
    });

    test('opens my test details for all my-test notification types', () {
      for (final type in [
        'test_purchase',
        'test_liked',
        'test_bookmarked',
        'test_marked_as_reported',
      ]) {
        final decision = resolver.resolve(
          _notification(
            type: type,
            screen: 'my_test_details',
            params: {'test_id': '29'},
          ),
        );

        expect(decision.routeName, AppRouterName.myTestDetails);
        expect((decision.extra as DetailsOfTestRouteArgs).testId, 29);
      }
    });

    test('opens the other user profile', () {
      final decision = resolver.resolve(
        _notification(
          type: 'user_followed_you',
          screen: 'user_profile',
          params: {'user_id': 35},
        ),
      );

      expect(decision.routeName, AppRouterName.otherProfile);
      expect((decision.extra as OtherProfileRouteArgs).userId, 35);
    });

    test('opens my material with isMyContent enabled', () {
      final decision = resolver.resolve(
        _notification(
          type: 'library_material_liked',
          screen: 'my_library_material_details',
          params: {'material_id': 12},
        ),
      );

      expect(decision.routeName, AppRouterName.otherContentDetails);
      final args = decision.extra as ContentDetailsRouteArgs;
      expect(args.contentId, 12);
      expect(args.isMyContent, isTrue);
    });

    test('opens another user material with isMyContent disabled', () {
      final decision = resolver.resolve(
        _notification(
          type: 'followed_user_published_library_material',
          screen: 'library_material_details',
          params: {'material_id': 18},
        ),
      );

      expect(decision.routeName, AppRouterName.otherContentDetails);
      final args = decision.extra as ContentDetailsRouteArgs;
      expect(args.contentId, 18);
      expect(args.isMyContent, isFalse);
    });

    test('blocks a force-deleted test', () {
      final decision = resolver.resolve(
        _notification(
          type: 'test_deleted_by_dashboard',
          screen: 'my_tests_details',
          params: {'test_id': 20, 'deletion_type': 'force_delete'},
        ),
      );

      expect(decision.canNavigate, isFalse);
      expect(decision.isBlocked, isTrue);
    });

    test('opens a soft-deleted test', () {
      final decision = resolver.resolve(
        _notification(
          type: 'test_deleted_by_dashboard',
          screen: 'my_tests_details',
          params: {'test_id': 20, 'deletion_type': 'soft_delete'},
        ),
      );

      expect(decision.routeName, AppRouterName.myTestDetails);
      expect((decision.extra as DetailsOfTestRouteArgs).testId, 20);
    });

    test('opens my profile for a ban notification', () {
      final decision = resolver.resolve(
        _notification(
          type: 'user_banned',
          screen: 'my_profile',
          params: {'user_id': 7},
        ),
      );

      expect(decision.routeName, AppRouterName.myProfile);
      expect((decision.extra as OtherProfileRouteArgs).userId, 7);
    });

    test('rejects missing required identifiers', () {
      final decision = resolver.resolve(
        _notification(
          type: 'test_liked',
          screen: 'my_test_details',
          params: const {},
        ),
      );

      expect(decision.canNavigate, isFalse);
      expect(decision.isBlocked, isFalse);
      expect(decision.message, contains('test_id'));
    });
  });
}

NotificationEntity _notification({
  required String type,
  required String screen,
  required Map<String, dynamic> params,
}) {
  return NotificationEntity(
    id: 'notification-id',
    mode: 'system',
    image: null,
    floorColor: null,
    icon: null,
    title: 'عنوان',
    body: 'نص الإشعار',
    sentAt: 'الآن',
    isRead: false,
    metadata: NotificationMetadataEntity(
      type: type,
      category: null,
      screen: screen,
      action: 'open',
      params: params,
    ),
  );
}
