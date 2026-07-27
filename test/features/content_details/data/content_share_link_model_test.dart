import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/content_details/data/models/content_share_link_model.dart';

void main() {
  test('parses the generated content share link response', () {
    final entity = ContentShareLinkModel.fromJson({
      'success': true,
      'title': '! تم جلب رابط المشاركة بنجاح',
      'data': {
        'share_slug': 'D7VGGGzBo5XrX1zcSUQ0xqun',
        'share_url': 'http://localhost/share/library/D7VGGGzBo5XrX1zcSUQ0xqun',
      },
      'status_code': 200,
    }).toEntity();

    expect(entity.success, isTrue);
    expect(entity.shareSlug, 'D7VGGGzBo5XrX1zcSUQ0xqun');
    expect(
      entity.shareUrl,
      'http://localhost/share/library/D7VGGGzBo5XrX1zcSUQ0xqun',
    );
  });

  test('parses shared content ownership and loose scalar values', () {
    final entity = SharedContentLinkModel.fromJson({
      'success': 1,
      'data': {'material_id': '1', 'is_owner': 'true'},
      'status_code': '200',
    }).toEntity();

    expect(entity.success, isTrue);
    expect(entity.materialId, 1);
    expect(entity.isOwner, isTrue);
    expect(entity.statusCode, 200);
  });

  test('builds the two library share endpoints', () {
    expect(EndPoints.contentShareLink(1), endsWith('/library/share-link/1'));
    expect(
      EndPoints.sharedContentLink('slug with spaces'),
      endsWith('/library/shared/slug%20with%20spaces'),
    );
  });
}
