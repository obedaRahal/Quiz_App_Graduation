import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';

void main() {
  testWidgets('uses a finite fallback icon size with infinite image bounds', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 100,
            height: 100,
            child: CustomAppImage(
              path: 'assets/images/does-not-exist.png',
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final fallbackIcon = tester.widget<Icon>(
      find.byIcon(Icons.broken_image_outlined),
    );

    expect(fallbackIcon.size, isNotNull);
    expect(fallbackIcon.size!.isFinite, isTrue);
    expect(tester.takeException(), isNull);
  });
}
