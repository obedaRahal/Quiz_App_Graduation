import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/core/common_widgets/app_keyboard_dismiss_scope.dart';

void main() {
  testWidgets('unfocuses a text field after a touch outside it', (
    tester,
  ) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) {
          return AppKeyboardDismissScope(
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: Scaffold(
          body: Column(
            children: [
              TextField(focusNode: focusNode),
              const SizedBox(key: Key('outside-area'), width: 200, height: 200),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);

    await tester.tap(find.byKey(const Key('outside-area')));
    await tester.pump();
    expect(focusNode.hasFocus, isFalse);
  });

  testWidgets('keeps focus when interacting inside the active field', (
    tester,
  ) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) {
          return AppKeyboardDismissScope(
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: Scaffold(body: TextField(focusNode: focusNode)),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.tap(find.byType(TextField));
    await tester.pump();

    expect(focusNode.hasFocus, isTrue);
  });
}
