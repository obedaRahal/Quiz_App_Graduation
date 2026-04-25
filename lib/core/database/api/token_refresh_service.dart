// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:quiz_app_grad/core/database/api/end_point.dart';
// import 'package:quiz_app_grad/core/database/cache/token_storage.dart';

// class TokenRefreshService {
//   final Dio dio;

//   TokenRefreshService({required this.dio});

//   Future<bool> refreshToken() async {
//     final oldToken = await TokenStorage.getAccessToken();

//     if (oldToken == null || oldToken.isEmpty) {
//       debugPrint('Refresh aborted: no access token found');
//       return false;
//     }

//     try {
//       final response = await dio.post(
//         EndPoints.refreshToken,
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $oldToken',
//           },
//           extra: {
//             'requiresAuth': false,
//           },
//         ),
//       );

//       final data = response.data['data'];

//       final newToken = data['newToken']?.toString();
//       final expiresIn = data['expires_in'];

//       if (newToken == null || newToken.isEmpty || expiresIn == null) {
//         return false;
//       }

//       await TokenStorage.saveAccessToken(
//         token: newToken,
//         expiresInSeconds: expiresIn is int
//             ? expiresIn
//             : int.parse(expiresIn.toString()),
//       );

//       debugPrint('Refresh token success');
//       return true;
//     } catch (e, s) {
//       debugPrint('Refresh token failed => $e');
//       debugPrint('Refresh token stack => $s');
//       return false;
//     }
//   }
// }