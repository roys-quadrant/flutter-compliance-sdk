# Documentation - Implementation  Consent Management SDK for Flutter
This documentation for implement Consent Management SDK for Flutter project.
To implement our Consent Management SDK you need to create Method Channel, we already prepare it for you.
# Android
## Add Maven
Add maven on your *build.gradle (Project)*
1 add this snippet inside dependencies
```groovy        classpath 'org.jfrog.buildinfo:build-info-extractor-gradle:4.21.0'```
2 add this snippet inside repositories
```groovy
        maven {
             url "https://quadrantsdk2.jfrog.io/artifactory/quadrant-sdk/"
        }
        apply  plugin: "com.jfrog.artifactory"
```
## Add Consent Management SDK
Now you can implement our SDK on your *build.gradle (App)*, you can add this snippet inside dependencies
implementation 'io.quadrant.sdk.compliance:compliancesdk:1.0.22'
## Apply Theme.AppCompact
In case you not apply Theme.AppCompact yet, you need to implement that
### Styles.xml (light)
add this code on your Styles.xml (light)
```xml
<style name="AppFullScreenTheme" parent="Theme.AppCompat.Light.NoActionBar">
    <item name="android:windowNoTitle">true</item>
    <item name="android:windowActionBar">false</item>
    <item name="android:windowFullscreen">true</item>
    <item name="android:windowContentOverlay">@null</item>
</style>
```
### Styles.xml (dark)
add this code on your Styles.xml (dark)
```xml
<style name="AppFullScreenTheme" parent="Theme.AppCompat.NoActionBar">
    <item name="android:windowNoTitle">true</item>
    <item name="android:windowActionBar">false</item>
    <item name="android:windowFullscreen">true</item>
    <item name="android:windowContentOverlay">@null</item>
</style>
```
### AndroidManifest.xml
and apply to our new theme to your activity, for example:
```xml
<activity
            android:name=".MainActivity"
            android:theme="@style/AppFullScreenTheme">
```
## Create Method Channel
Create kotlin file with name QDComplianceMethodChannel Copy this kotlin code
package com.example.compliance

```kotlin
import android.content.Context
import androidx.fragment.app.FragmentManager
import com.quadrant.sdk.compliance.core.Compliance
import com.quadrant.sdk.compliance.util.ConsentResult
import com.quadrant.sdk.compliance.util.PermissionUtil
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class QDComplianceMethodChannel(context: Context, fragmentManager: FragmentManager, flutterEngine: FlutterEngine, integrationKey: String) {

    private val CHANNEL = "io.quadrant.compliance"
    private val REQUEST_OPTOUT = 0
    private val REQUEST_DO_NOT_SELL = 1
    private val REQUEST_DELETE_DATA = 2
    private val REQUEST_ACCESS_DATA = 3

    var compliance: Compliance = Compliance.getInstance(integrationKey)
    init {

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->

            when (call.method) {
                "openConsentFormIfNeeded" -> openConsentFormIfNeeded(context, fragmentManager, result)
                "openConsentForm" -> openConsentForm(fragmentManager, call.argument<Int>("complianceType"), result)
                "optOut" -> optOut(context, fragmentManager,result)
                "doNotSell" -> doNotSell(context, fragmentManager,result)
                "deleteMyData" -> deleteMyData(context, fragmentManager,result)
                "requestMyData" -> requestMyData(context, fragmentManager,result)
            }
        }
    }

    private fun openConsentFormIfNeeded(context: Context, fragmentManager: FragmentManager, result: MethodChannel.Result) {
        if (!PermissionUtil.accessLocation(context)) return
        compliance.openConsentFormIfNeeded(context, fragmentManager, object: Compliance.ConsentCallback {
            override fun onSuccess(consentResult: ConsentResult?) {
                result.success(consentResult.toString())
            }

            override fun onError(errorMessage: String?) {
               result.error("", errorMessage,null)
            }

        })
    }

    private fun openConsentForm( fragmentManager: FragmentManager, complianceType: Int?, result: MethodChannel.Result) {
        complianceType?.let {
            compliance.openConsentForm(fragmentManager, complianceType, object : Compliance.ConsentCallback {
                override fun onSuccess(consentResult: ConsentResult?) {
                    result.success(consentResult.toString())
                }

                override fun onError(errorMessage: String?) {
                    result.error("", errorMessage,null)
                }
            })
        }
    }

    private fun optOut(context: Context, fragmentManager: FragmentManager, result: MethodChannel.Result) {
        compliance.requestCompliance(context, fragmentManager, REQUEST_OPTOUT, object: Compliance.ResultCallback {
            override fun onSuccess(p0: String?) {
                result.success(p0)
            }

            override fun onError(errorMessage: String?) {
                result.error("", errorMessage,null)
            }
        })
    }

    private fun doNotSell(context: Context, fragmentManager: FragmentManager, result: MethodChannel.Result) {
        compliance.requestCompliance(context, fragmentManager, REQUEST_DO_NOT_SELL, object: Compliance.ResultCallback {
            override fun onSuccess(p0: String?) {
                result.success(p0)
            }

            override fun onError(errorMessage: String?) {
                result.error("", errorMessage,null)
            }
        })
    }

    private fun deleteMyData(context: Context, fragmentManager: FragmentManager, result: MethodChannel.Result) {
        compliance.requestCompliance(context, fragmentManager, REQUEST_DELETE_DATA, object: Compliance.ResultCallback {
            override fun onSuccess(p0: String?) {
                result.success(p0)
            }

            override fun onError(errorMessage: String?) {
                result.error("", errorMessage,null)
            }
        })
    }

    private fun requestMyData(context: Context, fragmentManager: FragmentManager, result: MethodChannel.Result) {
        compliance.requestCompliance(context, fragmentManager, REQUEST_ACCESS_DATA, object: Compliance.ResultCallback {
            override fun onSuccess(p0: String?) {
                result.success(p0)
            }

            override fun onError(errorMessage: String?) {
                result.error("", errorMessage,null)
            }
        })
    }
}
```

## Setup Consent Management SDK with Method Channel
After we create method channel, now we can implement our SDK, for example we implement on MainActivity
```kotlin
class MainActivity: FlutterFragmentActivity() {
    var compliance: QDComplianceMethodChannel? = null
    private val INTEGRATION_KEY = "<your integration key>"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        compliance = QDComplianceMethodChannel(this, this.supportFragmentManager, flutterEngine, INTEGRATION_KEY)
    }
}
```

# iOS
## Permission
update your permission on Info.plist
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string><your description></string>
<key>NSUserTrackingUsageDescription</key>
<string><your description></string>
```
## Podfile
update your podfile to implement our sdk from github and make sure to update build_settings BUILD_LIBRARY_FOR_DISTRIBUTION = YES
```ruby
target 'Runner' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'QcmpSDK', :git => 'https://github.com/datastreamx-plc/QcmpSDK.git'

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end
```
## Create MethodChannel
Create swift file QDComplianceMethodChannel.swift and paste this source:
```swift
//
//  QDComplianceMethodChannel.swift
//  Runner
//
//  Created by saminos on 04/03/22.
//

import Foundation
import QcmpSDK

class QDComplianceMethodChannel: FlutterMethodChannel {
    private static let compliance = Compliance.shared
    private static let channel = "io.quadrant.compliance"
    
    @discardableResult
    static func setup(_ binaryMessenger: FlutterBinaryMessenger, integrationKey: String) -> QDComplianceMethodChannel {
        
        let methodChannel = QDComplianceMethodChannel(name: Self.channel, binaryMessenger: binaryMessenger)
        compliance.setup(integrationKey)
        methodChannel.setup()
        return methodChannel
    }
    
    private func setup() {
        setMethodCallHandler(Self.handler(call:result:))
    }
    
    private static func handler(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "openConsentFormIfNeeded":
            compliance.openConsentFormIfNeeded { (consentResult) in
                switch consentResult {
                case .success(let choosenConsent):
                    result(choosenConsent.rawValue)
                case .failure(let error):
                    result(FlutterError(code: "", message: error.errorDescription, details: nil))
                }
            }
            
        case "openConsentForm":
            guard let arguments = call.arguments as? [String: Any],
                  let complianceTypeRaw = arguments["complianceType"] as? Int,
                  let type = ComplianceType(rawValue: complianceTypeRaw)
            else { return }
            
            compliance.openConsentForm(complianceType: type) { consentResult in
                switch consentResult {
                case .success(let choosenConsent):
                    result(choosenConsent.rawValue)
                case .failure(let error):
                    result(FlutterError(code: "", message: error.errorDescription, details: nil))
                }
            }
            case "optOut":
            compliance.requestCompliance(requestType: .REQUEST_OPTOUT) { requestResult in
                switch requestResult {
                case .success:
                    result(true)
                case .failure(let error):
                    result(FlutterError(code: "", message: error.errorDescription, details: nil))
                }
            }
            case "doNotSell":
            compliance.requestCompliance(requestType: .REQUEST_DO_NOT_SELL) { requestResult in
                switch requestResult {
                case .success:
                    result(true)
                case .failure(let error):
                    result(FlutterError(code: "", message: error.errorDescription, details: nil))
                }
            }
            case "deleteMyData":
            compliance.requestCompliance(requestType: .REQUEST_DELETE_DATA) { requestResult in
                switch requestResult {
                case .success:
                    result(true)
                case .failure(let error):
                    result(FlutterError(code: "", message: error.errorDescription, details: nil))
                }
            }
            case "requestMyData":
            compliance.requestCompliance(requestType: .REQUEST_ACCESS_DATA) { requestResult in
                switch requestResult {
                case .success:
                    result(true)
                case .failure(let error):
                    result(FlutterError(code: "", message: error.errorDescription, details: nil))
                }
            }
            
        default: break;
        }
    }
}
```

## Setup Consent Management SDK with Method Channel
Update your AppDelegate to implement QcmpSDK using MethodChannel that we created before:
```swift
import UIKit
import Flutter
import QcmpSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    private let integrationKey = "<your integration key>"
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        QDComplianceMethodChannel.setup(controller.binaryMessenger, integrationKey: integrationKey)
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
     
}
```

# Flutter
## Create qdcompliance.dart
Create QDCompliance.dart on your flutter source and copy this code, this code will communicate with our method channel
```dart
import 'package:flutter/services.dart';

class QDCompliance {
  static const platform = MethodChannel('io.quadrant.compliance');

  static Future<T?> openConsentForm<T>(int complianceType) {
    return platform
        .invokeMethod<T>("openConsentForm", {"complianceType": complianceType});
  }

  static Future<T?> openConsentFormIfNeeded<T>() async {
    return platform.invokeMethod("openConsentFormIfNeeded");
  }

  static Future<T?> optOut<T>() async {
    return platform.invokeMethod("optOut");
  }

  static Future<T?> doNotSell<T>() async {
    return platform.invokeMethod("doNotSell");
  }

  static Future<T?> deleteMyData<T>() async {
    return platform.invokeMethod("deleteMyData");
  }

  static Future<T?> requestMyData<T>() async {
    return platform.invokeMethod("requestMyData");
  }
}

class ComplianceRequestType {
  static const OPTOUT = 0;
  static const DO_NOT_SELL = 1;
  static const DELETE_DATA = 2;
  static const ACCESS_DATA = 3;
}

class ComplianceType {
  static const GDPR = 0;
  static const CCPA = 1;
}
```
  
## Open Consent Form
You can open consent form for GDPR or CCPA from your .dart code
```dart
/// to open gdpr consent form
QDCompliance.openConsentForm(ComplianceType.GDPR);

/// to open ccpa consent form
QDCompliance.openConsentForm(ComplianceType.CCPA);
```

## Init Compliance Request
You can request compliance (Request Access Data, Request Delete Data, Request Do Not Sell Data, Request Opt Out) from your .dart code
```dart
/// to request access data
QDCompliance.initComplianceRequest(ComplianceRequestType.ACCESS_DATA);

/// to request delete data
QDCompliance.initComplianceRequest(ComplianceRequestType.DELETE_DATA);

/// to request do not sell data
QDCompliance.initComplianceRequest(ComplianceRequestType.DO_NOT_SELL);

/// to request opt out data
QDCompliance.initComplianceRequest(ComplianceRequestType.OPTOUT);
```
  
## Full Example main.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'qdcompliance.dart';

void main() {
  runApp(const MyApp());
}

Widget _buildPopupDialog(BuildContext context, String title, String message,
    String buttonTitle, Function buttonAction,
    {String? secondButtonTitle, Function? secondButtonAction}) {
  return AlertDialog(
    title: Text(title),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(message),
      ],
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          buttonAction();
          Navigator.of(context).pop();
        },
        child: Text(buttonTitle),
      ),
      if (secondButtonTitle != null)
        TextButton(
            onPressed: () {
              if (secondButtonAction != null) secondButtonAction();
              Navigator.of(context).pop();
            },
            child: Text(buttonTitle)),
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _openGDPR() {
    QDCompliance.openConsentForm(ComplianceType.GDPR).then((value) {
      String? valueObj = cast(value);
      if (valueObj == null) return;

      print(valueObj);
    }).catchError((error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupDialog(
                  context, "Error", error.toString(), "buttonTitle", () {
                print("button clicked");
              }));
    });
  }

  void _openCCPA() {
    QDCompliance.openConsentForm(ComplianceType.CCPA);
  }

  void _openConsentIfNeeded() {
    QDCompliance.openConsentFormIfNeeded();
  }

  Future<T?> optOut<T>() {
    const platform = MethodChannel('io.quadrant.compliance');
    return platform.invokeMethod<T>("optOut");
  }

  T? cast<T>(x) => x is T ? x : null;

  // void _handleError(e:)

  void _showRequestSuccess(String request) {
    showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(
            context,
            "Success",
            "Your '" + request + "' request has been sent to our data",
            "Nice",
            () {}));
  }

  void _showError(dynamic error) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            _buildPopupDialog(context, "Error", error.toString(), "OK", () {}));
  }

  void _runConsentRequest<T>(
      Future<dynamic> Function() futureFunction, String name) {
    showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(context, name,
                "Are you sure you want to '" + name + "'?", "Yes", () {
              futureFunction().then((value) {
                bool? valueObj = cast(value);
                if (valueObj != true) return;

                _showRequestSuccess(name);
              }).catchError((error) {
                _showError(error);
              });
            }));
  }

  void _optOut() {
    _runConsentRequest(QDCompliance.optOut, "Opt Out");
  }

  void _doNotSell() {
    _runConsentRequest(QDCompliance.doNotSell, "Do Not Sell My Data");
  }

  void _deleteMyData() {
    _runConsentRequest(QDCompliance.deleteMyData, "Delete My Data");
  }

  void _requestMyData() {
    _runConsentRequest(QDCompliance.requestMyData, "Request My Data");
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                "Open Consent",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              alignment: Alignment(-1, 0),
            ),
            Container(
              alignment: Alignment(-1, 0),
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: _openConsentIfNeeded,
                      child: const Text('Open If Needed')),
                  TextButton(
                      onPressed: _openGDPR, child: const Text('Open GDPR')),
                  TextButton(
                      onPressed: _openCCPA, child: const Text('Open CCPA')),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                "Data and Privacy",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              alignment: Alignment(-1, 0),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(onPressed: _optOut, child: const Text('Opt Out')),
                  TextButton(
                      onPressed: _doNotSell,
                      child: const Text('Do Not Sell My Personal Information')),
                  TextButton(
                      onPressed: _deleteMyData,
                      child: const Text('Delete My Data')),
                  TextButton(
                      onPressed: _requestMyData,
                      child: const Text('Request My Data')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
```
