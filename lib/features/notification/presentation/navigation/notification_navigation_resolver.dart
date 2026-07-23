import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/features/content_details/presentation/route_args/content_details_route_args.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/details_of_test_route_args.dart';
import 'package:quiz_app_grad/features/notification/domain/entities/notification_entity.dart';
import 'package:quiz_app_grad/features/other_profile/data/models/other_profile_route_args.dart';

class NotificationNavigationDecision {
  final String? routeName;
  final Object? extra;
  final String? message;
  final bool isBlocked;

  const NotificationNavigationDecision._({
    this.routeName,
    this.extra,
    this.message,
    this.isBlocked = false,
  });

  const NotificationNavigationDecision.navigate({
    required String routeName,
    required Object extra,
  }) : this._(routeName: routeName, extra: extra);

  const NotificationNavigationDecision.blocked(String message)
    : this._(message: message, isBlocked: true);

  const NotificationNavigationDecision.invalid(String message)
    : this._(message: message);

  bool get canNavigate => routeName != null;
}

class NotificationNavigationResolver {
  const NotificationNavigationResolver();

  NotificationNavigationDecision resolve(NotificationEntity notification) {
    final metadata = notification.metadata;
    final action = metadata.action?.trim().toLowerCase();
    final screen = metadata.screen?.trim().toLowerCase();

    if (action != 'open') {
      return const NotificationNavigationDecision.invalid(
        'هذا الإشعار لا يحتوي على إجراء فتح مدعوم.',
      );
    }

    switch (screen) {
      case 'public_test_details':
        return _testDetailsDecision(
          params: metadata.params,
          routeName: AppRouterName.detailsOfTest,
        );

      case 'my_test_details':
        return _testDetailsDecision(
          params: metadata.params,
          routeName: AppRouterName.myTestDetails,
        );

      case 'my_tests_details':
        return _deletedTestDecision(notification);

      case 'user_profile':
        final userId = metadata.userId;

        if (userId == null) {
          return _missingParameter('user_id');
        }

        return NotificationNavigationDecision.navigate(
          routeName: AppRouterName.otherProfile,
          extra: OtherProfileRouteArgs(userId: userId),
        );

      case 'my_library_material_details':
        return _contentDetailsDecision(
          params: metadata.params,
          isMyContent: true,
        );

      case 'library_material_details':
        return _contentDetailsDecision(
          params: metadata.params,
          isMyContent: false,
        );

      case 'my_profile':
        final userId = _positiveInt(metadata.params['user_id']);

        if (userId == null) {
          return _missingParameter('user_id');
        }

        return NotificationNavigationDecision.navigate(
          routeName: AppRouterName.myProfile,
          extra: OtherProfileRouteArgs(userId: userId),
        );

      default:
        return const NotificationNavigationDecision.invalid(
          'الوجهة المرتبطة بهذا الإشعار غير مدعومة حالياً.',
        );
    }
  }

  NotificationNavigationDecision _testDetailsDecision({
    required Map<String, dynamic> params,
    required String routeName,
  }) {
    final testId = _positiveInt(params['test_id']);

    if (testId == null) {
      return _missingParameter('test_id');
    }

    return NotificationNavigationDecision.navigate(
      routeName: routeName,
      extra: DetailsOfTestRouteArgs(testId: testId),
    );
  }

  NotificationNavigationDecision _deletedTestDecision(
    NotificationEntity notification,
  ) {
    final deletionType = notification.metadata.deletionType?.toLowerCase();

    if (deletionType == 'force_delete') {
      return const NotificationNavigationDecision.blocked(
        'تم حذف هذا الاختبار نهائياً، لذلك لم يعد من الممكن فتحه.',
      );
    }

    if (deletionType != 'soft_delete') {
      return const NotificationNavigationDecision.invalid(
        'تعذر تحديد حالة الاختبار المحذوف.',
      );
    }

    return _testDetailsDecision(
      params: notification.metadata.params,
      routeName: AppRouterName.myTestDetails,
    );
  }

  NotificationNavigationDecision _contentDetailsDecision({
    required Map<String, dynamic> params,
    required bool isMyContent,
  }) {
    final materialId = _positiveInt(params['material_id']);

    if (materialId == null) {
      return _missingParameter('material_id');
    }

    return NotificationNavigationDecision.navigate(
      routeName: AppRouterName.otherContentDetails,
      extra: ContentDetailsRouteArgs(
        contentId: materialId,
        isMyContent: isMyContent,
      ),
    );
  }

  NotificationNavigationDecision _missingParameter(String name) {
    return NotificationNavigationDecision.invalid(
      'تعذر فتح الوجهة لأن المعطى $name غير موجود أو غير صالح.',
    );
  }

  int? _positiveInt(dynamic value) {
    final parsed = value is int
        ? value
        : int.tryParse(value?.toString().trim() ?? '');

    return parsed != null && parsed > 0 ? parsed : null;
  }
}
