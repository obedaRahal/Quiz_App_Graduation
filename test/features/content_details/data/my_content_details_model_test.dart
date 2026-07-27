import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/content_details/data/models/my_content_details/my_content_details_model.dart';

void main() {
  test('parses all public content details and preserves status order', () {
    final model = MyContentDetailsModel.fromJson({
      'success': true,
      'data': {
        'basic_info': {
          'id': 2,
          'title': 'دليل مراجعة الرياضيات',
          'description': 'وصف المحتوى',
          'interests': ['الرياضيات', 'علوم الحاسوب'],
          'target_level': 'سنة أولى جامعة',
          'content_kind': 'صور مجمعة',
          'visibility_type': 'عام',
          'asset_count': 2,
          'published_at': '02 May 2025',
          'assets': [
            {'id': 3, 'url': 'second.jpg', 'position': 2},
            {'id': 2, 'url': 'first.jpg', 'position': 1},
          ],
          'like_count': 4,
          'bookmarks_count': 5,
          'download_count': 7,
          'review_status': 'تم الموافقة عليه',
        },
        'status_history': [
          {
            'id': 9,
            'from_status': 'تم الموافقة عليه',
            'to_status': 'مبلغ عنه',
            'note': 'هذا المحتوى غير لائق',
            'happened_at': 'منذ دقيقة',
          },
          {
            'id': 10,
            'from_status': 'مبلغ عنه',
            'to_status': 'تم حذفه',
            'note': 'تم حذف المحتوى',
            'happened_at': 'منذ دقيقة',
          },
        ],
      },
      'status_code': 200,
    });

    expect(model.basicInfo.likeCount, 4);
    expect(model.basicInfo.bookmarksCount, 5);
    expect(model.basicInfo.downloadCount, 7);
    expect(model.basicInfo.reviewStatus, 'تم الموافقة عليه');
    expect(model.basicInfo.isPublic, isTrue);
    expect(model.basicInfo.assets.first.position, 1);

    // The API contract defines index zero as the current status.
    expect(model.statusHistory.first.id, 9);
    expect(model.statusHistory.first.toStatus, 'مبلغ عنه');
    expect(model.statusHistory[1].id, 10);
  });

  test(
    'parses private content when optional public-only fields are absent',
    () {
      final model = MyContentDetailsModel.fromJson({
        'data': {
          'basic_info': {
            'id': '2',
            'title': 'محتوى خاص',
            'description': 'وصف',
            'interests': <String>[],
            'target_level': 'جامعي',
            'content_kind': 'ملف',
            'visibility_type': 'خاص',
            'asset_count': '1',
            'assets': [
              {'id': 1, 'url': 'file.pdf', 'position': 1},
            ],
          },
        },
      });

      expect(model.basicInfo.id, 2);
      expect(model.basicInfo.likeCount, 0);
      expect(model.basicInfo.reviewStatus, isEmpty);
      expect(model.statusHistory, isEmpty);
      expect(model.basicInfo.isPublic, isFalse);
    },
  );

  test('builds separate public and private owner endpoints', () {
    expect(
      EndPoints.myPublicContentDetails(2),
      '/library/library-materials-details/my-public/2',
    );
    expect(
      EndPoints.myPrivateContentDetails(2),
      '/library/library-materials-details/my-private/2',
    );
  });
}
