import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/core/services/deep_link/deep_link_service.dart';

void main() {
  test('parses a library material deep link', () {
    final target = DeepLinkService.parseUri(
      Uri.parse('nerd://library/D7VGGGzBo5XrX1zcSUQ0xqun'),
    );

    expect(target, isNotNull);
    expect(target!.kind, AppDeepLinkKind.library);
    expect(target.slug, 'D7VGGGzBo5XrX1zcSUQ0xqun');
  });

  test('keeps parsing the existing test deep link', () {
    final target = DeepLinkService.parseUri(
      Uri.parse('nerd://tests/test-share-slug'),
    );

    expect(target, isNotNull);
    expect(target!.kind, AppDeepLinkKind.test);
    expect(target.slug, 'test-share-slug');
  });

  test('parses a shared profile deep link', () {
    final target = DeepLinkService.parseUri(
      Uri.parse('nerd://profiles/profile-share-slug'),
    );

    expect(target, isNotNull);
    expect(target!.kind, AppDeepLinkKind.profile);
    expect(target.slug, 'profile-share-slug');
  });

  test('rejects unsupported and malformed deep links', () {
    expect(DeepLinkService.parseUri(Uri.parse('https://library/slug')), isNull);
    expect(DeepLinkService.parseUri(Uri.parse('nerd://library')), isNull);
  });
}
