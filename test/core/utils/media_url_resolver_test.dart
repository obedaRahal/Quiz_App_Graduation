import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/core/utils/media_url_resolver.dart';

void main() {
  test('replaces localhost media host with the API server host', () {
    final resolved = resolveMediaUrl(
      'http://localhost/storage/library/content.jpg',
      apiBaseUrl: 'http://192.168.1.110/api/v1/user-mobile',
    );

    expect(
      resolved,
      'http://192.168.1.110/storage/library/content.jpg',
    );
  });

  test('preserves non-localhost and asset paths', () {
    expect(
      resolveMediaUrl(
        'https://cdn.example.com/content.jpg',
        apiBaseUrl: 'http://192.168.1.110/api/v1/user-mobile',
      ),
      'https://cdn.example.com/content.jpg',
    );
    expect(
      resolveMediaUrl(
        'assets/images/content.jpg',
        apiBaseUrl: 'http://192.168.1.110/api/v1/user-mobile',
      ),
      'assets/images/content.jpg',
    );
  });
}
