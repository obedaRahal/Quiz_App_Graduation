
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/test_interaction_users_cubit/cubit/test_interaction_users_state.dart';

class GetTestInteractionUsersParams {
  final int testId;
  final String? search;
  final String? cursor;
  final TestInteractionUsersType type;

  const GetTestInteractionUsersParams({
    required this.testId,
    required this.type,
    this.search,
    this.cursor,
  });
}