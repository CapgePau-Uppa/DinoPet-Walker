import UIKit
import Flutter
// 1. On importe le package en natif
import flutter_foreground_task

// 2. On crée cette fonction indispensable en dehors de la classe
func registerPlugins(registry: FlutterPluginRegistry) {
  GeneratedPluginRegistrant.register(with: registry)
}

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // 3. On connecte le plugin d'arrière-plan au système iOS
    SwiftFlutterForegroundTaskPlugin.setPluginRegistrantCallback(registerPlugins)

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}