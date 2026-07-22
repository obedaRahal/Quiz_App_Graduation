import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/test_follow_action_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/follow_creator_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/test_follow_action_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/unfollow_creator_use_case.dart';
import 'package:quiz_app_grad/features/search/domain/entities/search_user_entity.dart';
import 'package:quiz_app_grad/features/search/domain/use_cases/params/search_users_params.dart';
import 'package:quiz_app_grad/features/search/domain/use_cases/search_users_use_case.dart';
import 'package:quiz_app_grad/features/search/presentation/manager/search/search_cubit.dart';

class MockSearchUsersUseCase extends Mock implements SearchUsersUseCase {}

class MockFollowCreatorUseCase extends Mock implements FollowCreatorUseCase {}

class MockUnfollowCreatorUseCase extends Mock
    implements UnfollowCreatorUseCase {}

void main() {
  late MockSearchUsersUseCase searchUsersUseCase;
  late MockFollowCreatorUseCase followCreatorUseCase;
  late MockUnfollowCreatorUseCase unfollowCreatorUseCase;
  late SearchCubit cubit;

  setUpAll(() {
    registerFallbackValue(const SearchUsersParams(query: 'query'));
    registerFallbackValue(const TestFollowActionParams(creatorId: 1));
  });

  setUp(() {
    searchUsersUseCase = MockSearchUsersUseCase();
    followCreatorUseCase = MockFollowCreatorUseCase();
    unfollowCreatorUseCase = MockUnfollowCreatorUseCase();
    cubit = SearchCubit(
      searchUsersUseCase: searchUsersUseCase,
      followCreatorUseCase: followCreatorUseCase,
      unfollowCreatorUseCase: unfollowCreatorUseCase,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  test(
    'keeps the newest results when an older request finishes last',
    () async {
      final oldRequest =
          Completer<Either<Failure, SearchUsersResponseEntity>>();
      final newRequest =
          Completer<Either<Failure, SearchUsersResponseEntity>>();

      when(() => searchUsersUseCase(any())).thenAnswer((invocation) {
        final params =
            invocation.positionalArguments.first as SearchUsersParams;
        return params.query == 'قديم' ? oldRequest.future : newRequest.future;
      });

      final oldFuture = cubit.search(query: 'قديم');
      final newFuture = cubit.search(query: 'جديد');

      newRequest.complete(Right(_response(userId: 2, userName: 'الجديد')));
      await newFuture;

      oldRequest.complete(Right(_response(userId: 1, userName: 'القديم')));
      await oldFuture;

      expect(cubit.state.query, 'جديد');
      expect(cubit.state.users.single.id, 2);
      expect(cubit.state.users.single.name, 'الجديد');
    },
  );

  test('shows a load-more error and succeeds when retried', () async {
    var loadMoreAttempts = 0;

    when(() => searchUsersUseCase(any())).thenAnswer((invocation) async {
      final params = invocation.positionalArguments.first as SearchUsersParams;

      if (params.cursor == null) {
        return Right(
          _response(
            userId: 1,
            userName: 'الأول',
            nextCursor: 'next-page',
            hasMorePages: true,
          ),
        );
      }

      loadMoreAttempts++;
      if (loadMoreAttempts == 1) {
        return const Left(
          ServerFailure(title: 'خطأ', message: 'تعذر تحميل المزيد'),
        );
      }

      return Right(_response(userId: 2, userName: 'الثاني'));
    });

    await cubit.search(query: 'مستخدم');
    await cubit.fetchMoreIfNeeded();

    expect(cubit.state.hasLoadMoreError, isTrue);
    expect(cubit.state.users.map((user) => user.id), [1]);

    await cubit.fetchMoreIfNeeded();

    expect(cubit.state.hasLoadMoreError, isFalse);
    expect(cubit.state.users.map((user) => user.id), [1, 2]);
  });

  test('follows and unfollows the selected user', () async {
    when(
      () => searchUsersUseCase(any()),
    ).thenAnswer((_) async => Right(_response(userId: 7, userName: 'سارة')));
    when(() => followCreatorUseCase(any())).thenAnswer(
      (_) async => const Right(
        TestFollowActionEntity(
          success: true,
          title: 'تم',
          message: 'تمت المتابعة',
          statusCode: 200,
        ),
      ),
    );
    when(() => unfollowCreatorUseCase(any())).thenAnswer(
      (_) async => const Right(
        TestFollowActionEntity(
          success: true,
          title: 'تم',
          message: 'تم إلغاء المتابعة',
          statusCode: 200,
        ),
      ),
    );

    await cubit.search(query: 'سارة');
    await cubit.toggleFollowUser(userId: 7);

    expect(cubit.state.users.single.viewerIsFollowing, isTrue);
    verify(() => followCreatorUseCase(any())).called(1);

    await cubit.toggleFollowUser(userId: 7);

    expect(cubit.state.users.single.viewerIsFollowing, isFalse);
    verify(() => unfollowCreatorUseCase(any())).called(1);
  });
}

SearchUsersResponseEntity _response({
  required int userId,
  required String userName,
  String? nextCursor,
  bool hasMorePages = false,
}) {
  return SearchUsersResponseEntity(
    users: [
      SearchUserEntity(
        id: userId,
        name: userName,
        avatarUrl: '',
        academicLevel: '',
        isAcademicallyVerified: false,
        viewerIsFollowing: false,
      ),
    ],
    meta: SearchPaginationMetaEntity(
      perPage: 10,
      nextCursor: nextCursor,
      previousCursor: null,
      hasMorePages: hasMorePages,
    ),
  );
}
