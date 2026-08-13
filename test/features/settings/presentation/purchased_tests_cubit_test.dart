import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_app_grad/features/settings/domain/entity/purchased_tests_entity.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/fetch_purchased_tests_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/fetch_purchased_tests_params.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/purchased_tests/purchased_tests_cubit.dart';

class MockFetchPurchasedTestsUseCase extends Mock
    implements FetchPurchasedTestsUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(const FetchPurchasedTestsParams(tab: 'today'));
  });

  test('filters the loaded tests locally without another API request', () async {
    final fetchPurchasedTestsUseCase = MockFetchPurchasedTestsUseCase();
    final cubit = PurchasedTestsCubit(
      fetchPurchasedTestsUseCase: fetchPurchasedTestsUseCase,
    );

    const response = PurchasedTestsEntity(
      success: true,
      title: 'تم الجلب',
      statusCode: 200,
      tests: [
        PurchasedTestEntity(
          id: 1,
          title: 'اختبار الفيزياء',
          description: 'اختبار شامل في الفيزياء',
          interests: ['الفيزياء'],
          difficultyLevel: 'سهل',
          averageRating: 4,
          price: '1000.00',
          publishedAt: '1 March 2026',
          questionCount: 10,
          purchasedAt: '2026-08-05 15:25:26',
        ),
        PurchasedTestEntity(
          id: 2,
          title: 'اختبار الكيمياء',
          description: 'اختبار شامل في الكيمياء',
          interests: ['الكيمياء'],
          difficultyLevel: 'متوسط',
          averageRating: 3,
          price: '2000.00',
          publishedAt: '2 March 2026',
          questionCount: 12,
          purchasedAt: '2026-08-04 15:25:26',
        ),
      ],
    );

    when(
      () => fetchPurchasedTestsUseCase(any()),
    ).thenAnswer((_) async => const Right(response));

    await cubit.fetchInitial();
    cubit.search('فيزياء');

    expect(cubit.state.filteredTests, hasLength(1));
    expect(cubit.state.filteredTests.single.id, 1);
    verify(() => fetchPurchasedTestsUseCase(any())).called(1);

    await cubit.close();
  });
}
