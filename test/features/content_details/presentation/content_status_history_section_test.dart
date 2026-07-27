import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/content_details/presentation/widget/content_details_demo_data.dart';
import 'package:quiz_app_grad/features/content_details/presentation/widget/content_status_history_section.dart';

void main() {
  testWidgets('shows the first API history item as the current status', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            SizeConfig.init(context);

            return const Scaffold(
              body: SingleChildScrollView(
                child: ContentStatusHistorySection(
                  reviewStatus: 'تم الموافقة عليه',
                  history: [
                    ContentStatusHistoryUiData(
                      id: 9,
                      fromStatus: 'تم الموافقة عليه',
                      toStatus: 'مبلغ عنه',
                      note: 'بلاغ قيد المعالجة',
                      happenedAt: 'منذ دقيقة',
                    ),
                    ContentStatusHistoryUiData(
                      id: 10,
                      fromStatus: 'مبلغ عنه',
                      toStatus: 'تم حذفه',
                      note: 'قرار سابق',
                      happenedAt: 'منذ دقيقتين',
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('الحالة الحالية'), findsOneWidget);
    expect(find.text('الحالات السابقة'), findsOneWidget);
    expect(find.text('مبلغ عنه'), findsOneWidget);
    expect(find.text('تم حذفه'), findsOneWidget);

    final currentStatusTop = tester.getTopLeft(find.text('مبلغ عنه')).dy;
    final previousStatusTop = tester.getTopLeft(find.text('تم حذفه')).dy;
    expect(currentStatusTop, lessThan(previousStatusTop));
  });
}
