import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_connections_type.dart';

class GetOtherProfileConnectionsParams {
  final int userId;
  final OtherProfileConnectionsType type;
  final String search;
  final String? cursor;

  const GetOtherProfileConnectionsParams({
    required this.userId,
    required this.type,
    this.search = '',
    this.cursor,
  });
}