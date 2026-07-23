import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quiz_app_grad/core/services/notification/fcm_token.dart';
import 'package:uuid/uuid.dart';

class LoginDeviceMetadata {
  final String? fcmToken;
  final String? deviceId;
  final String? deviceName;

  const LoginDeviceMetadata({this.fcmToken, this.deviceId, this.deviceName});
}

abstract interface class LoginDeviceMetadataService {
  Future<LoginDeviceMetadata> getMetadata();
}

class LoginDeviceMetadataServiceImpl implements LoginDeviceMetadataService {
  static const String _installationIdKey = 'login_device_installation_id';

  final FlutterSecureStorage secureStorage;
  final Uuid uuid;

  const LoginDeviceMetadataServiceImpl({
    required this.secureStorage,
    required this.uuid,
  });

  @override
  Future<LoginDeviceMetadata> getMetadata() async {
    final fcmToken = _getFcmToken();
    final deviceId = await _getOrCreateInstallationId();
    final deviceName = await _getDeviceName();

    return LoginDeviceMetadata(
      fcmToken: fcmToken,
      deviceId: deviceId,
      deviceName: deviceName,
    );
  }

  String? _getFcmToken() {
    try {
      return _nonEmpty(FcmTokenStorage.getToken());
    } catch (error, stackTrace) {
      debugPrint('Failed to resolve FCM token for login: $error');
      debugPrint('$stackTrace');
      return null;
    }
  }

  Future<String?> _getOrCreateInstallationId() async {
    try {
      final storedId = _nonEmpty(
        await secureStorage.read(key: _installationIdKey),
      );

      if (storedId != null) {
        return storedId;
      }

      final generatedId = uuid.v4();
      await secureStorage.write(key: _installationIdKey, value: generatedId);
      return generatedId;
    } catch (error, stackTrace) {
      debugPrint('Failed to resolve login device id: $error');
      debugPrint('$stackTrace');
      return null;
    }
  }

  Future<String?> _getDeviceName() async {
    try {
      final hostname = _nonEmpty(Platform.localHostname);
      if (hostname != null && hostname.toLowerCase() != 'localhost') {
        return hostname;
      }

      return _platformDisplayName();
    } catch (error, stackTrace) {
      debugPrint('Failed to resolve login device name: $error');
      debugPrint('$stackTrace');
      return _platformDisplayName();
    }
  }

  String _platformDisplayName() {
    final operatingSystem = _nonEmpty(Platform.operatingSystem);
    final operatingSystemVersion = _nonEmpty(Platform.operatingSystemVersion);

    if (operatingSystem == null) {
      return 'unknown';
    }

    return operatingSystemVersion == null
        ? operatingSystem
        : '$operatingSystem $operatingSystemVersion';
  }
}

String? _nonEmpty(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}
