import 'dart:math';

import 'package:flutter/services.dart';

class QDCompliance {
  static const platform = MethodChannel('io.quadrant.compliance');

  static void openConsentForm(int complianceType) async {
    String result = await platform.invokeMethod("openConsentForm", {
      "complianceType": complianceType
    });

    print(result);
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