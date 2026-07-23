import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/notification/data/models/notification_model.dart';

void main() {
  group('NotificationModel media URLs', () {
    test('replaces localhost with the configured API host', () {
      final model = NotificationModel.fromJson({
        'id': 'notification-id',
        'mode': 'system',
        'image': 'http://localhost/storage/avatar.svg',
        'floor_color': '#FFE7E7',
        'icon': 'http://127.0.0.1/storage/flag.svg',
        'title': 'عنوان',
        'body': 'نص الإشعار',
        'sent_at': 'الآن',
        'is_read': false,
        'metadata': <String, dynamic>{},
      });

      final apiUri = Uri.parse(EndPoints.baseUrl);

      expect(
        model.image,
        '${apiUri.scheme}://${apiUri.host}/storage/avatar.svg',
      );
      expect(model.icon, '${apiUri.scheme}://${apiUri.host}/storage/flag.svg');
    });

    test('treats empty media values as missing', () {
      final model = NotificationModel.fromJson({
        'id': 'notification-id',
        'mode': 'user',
        'image': '  ',
        'floor_color': null,
        'icon': 'null',
        'title': 'عنوان',
        'body': 'نص الإشعار',
        'sent_at': 'الآن',
        'is_read': false,
        'metadata': <String, dynamic>{},
      });

      expect(model.image, isNull);
      expect(model.icon, isNull);
    });
  });

  test('parses the complete metadata payload and typed navigation params', () {
    final model = NotificationModel.fromJson({
      'id': 'notification-id',
      'mode': 'system',
      'image': null,
      'floor_color': '#FFE7E7',
      'icon': 'http://localhost/storage/flag.svg',
      'title': 'Title',
      'body': 'Body',
      'sent_at': 'Now',
      'is_read': true,
      'metadata': {
        'type': 'user_banned',
        'category': 'system',
        'presentation': {
          'mode': 'system',
          'floor_color': '#FFE7E7',
          'icon': 'http://localhost/storage/flag.svg',
        },
        'actor': {
          'id': '35',
          'name': 'Actor',
          'avatar_url': 'http://localhost/storage/avatar.svg',
        },
        'navigation': {'screen': 'my_profile', 'action': 'open'},
        'params': {
          'test_id': '29',
          'buyer_user_id': 21,
          'actor_user_id': '35',
          'material_id': 12,
          'creator_user_id': '8',
          'user_id': 7,
          'ban_id': '3',
          'deletion_type': 'soft_delete',
          'ban_type': 'temporary',
          'is_permanent': false,
        },
        'notification_key': 'notification-key',
      },
    });

    final metadata = model.metadata;

    expect(metadata.presentation?.mode, 'system');
    expect(metadata.presentation?.floorColor, '#FFE7E7');
    expect(metadata.actor?.id, 35);
    expect(metadata.actor?.name, 'Actor');
    expect(metadata.testId, 29);
    expect(metadata.buyerUserId, 21);
    expect(metadata.actorUserId, 35);
    expect(metadata.materialId, 12);
    expect(metadata.creatorUserId, 8);
    expect(metadata.userId, 7);
    expect(metadata.banId, 3);
    expect(metadata.deletionType, 'soft_delete');
    expect(metadata.banType, 'temporary');
    expect(metadata.isPermanent, isFalse);
    expect(metadata.notificationKey, 'notification-key');
  });
}
