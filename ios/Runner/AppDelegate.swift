import UIKit
import Flutter
import QcmpSDK
import netfox

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    
    
    private let integrationKey = "55b1055d4eafb6c05fdcfa01bf9ff2f6"
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        NFX.sharedInstance().start()
        
        QDComplianceMethodChannel.setup(controller.binaryMessenger, integrationKey: integrationKey)
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
}
