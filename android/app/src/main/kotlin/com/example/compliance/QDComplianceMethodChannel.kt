package com.example.compliance

import android.content.Context
import androidx.fragment.app.FragmentManager
import com.quadrant.sdk.compliance.core.Compliance
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
//
//enum class ComplianceRequestType {
//    REQUEST_OPTOUT,
//    REQUEST_DO_NOT_SELL,
//    REQUEST_DELETE_DATA,
//    REQUEST_ACCESS_DATA,
//}
//
//enum class ComplianceType {
//    GDPR,
//    CCPA
//}

class QDComplianceMethodChannel(fragmentManager: FragmentManager, flutterEngine: FlutterEngine, integrationKey: String) {

    private val CHANNEL = "io.quadrant.compliance"

    private var compliance: Compliance = Compliance.getInstance(integrationKey)
    init {

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->

            if (call.method == "openConsentForm") {
                val complianceType = call.argument<Int>("complianceType")
                if (fragmentManager != null && complianceType != null)
                    compliance.openConsentForm(fragmentManager, complianceType)
                else
                    result.success("argument: "+call.arguments);
            } else if (call.method == "initComplianceRequest") {
                val context = call.argument<Context>("context")
                val complianceRequestType = call.argument<Int>("complianceRequestType")
                val callback = call.argument<Compliance.ResultCallback>("callback")

                if (context != null && fragmentManager != null && complianceRequestType != null && callback != null)
                compliance.initComplianceRequest(context, fragmentManager,complianceRequestType,callback)
            }
        }
    }

}