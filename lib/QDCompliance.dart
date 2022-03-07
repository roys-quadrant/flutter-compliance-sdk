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
