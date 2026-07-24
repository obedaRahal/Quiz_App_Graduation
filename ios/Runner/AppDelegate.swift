import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: "quiz_app_grad/system_settings",
        binaryMessenger: controller.binaryMessenger
      )

      channel.setMethodCallHandler { call, result in
        guard call.method == "openNotificationSettings" else {
          result(FlutterMethodNotImplemented)
          return
        }

        let settingsUrl: URL?
        if #available(iOS 16.0, *) {
          settingsUrl = URL(string: UIApplication.openNotificationSettingsURLString)
        } else {
          settingsUrl = URL(string: UIApplication.openSettingsURLString)
        }

        guard let url = settingsUrl else {
          result(
            FlutterError(
              code: "notification_settings_unavailable",
              message: "Notification settings URL is unavailable.",
              details: nil
            )
          )
          return
        }

        UIApplication.shared.open(url) { opened in
          if opened {
            result(nil)
          } else {
            result(
              FlutterError(
                code: "notification_settings_unavailable",
                message: "Could not open notification settings.",
                details: nil
              )
            )
          }
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
