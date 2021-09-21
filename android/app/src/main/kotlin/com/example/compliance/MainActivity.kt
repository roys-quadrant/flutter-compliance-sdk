package com.example.compliance

import android.content.Context
import androidx.fragment.app.FragmentManager
import com.quadrant.sdk.compliance.core.Compliance
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterFragmentActivity() {
//    var compliance: QDComplianceMethodChannel? = null
    private val INTEGRATION_KEY = "1bfc5d9df8830245c482660849809272"
    private val CHANNEL = "io.quadrant.compliance"
    private var compliance: Compliance = Compliance.getInstance(INTEGRATION_KEY)

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
//        compliance = QDComplianceMethodChannel(this.supportFragmentManager, flutterEngine, INTEGRATION_KEY)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->

            if (call.method == "openConsentForm") {
                val complianceType = call.argument<Int>("complianceType")
                if (supportFragmentManager != null && complianceType != null)
                    compliance.openConsentForm(supportFragmentManager, complianceType)
                else
                    result.success("argument: "+call.arguments);
            } else if (call.method == "initComplianceRequest") {
                val context = call.argument<Context>("context")
                val complianceRequestType = call.argument<Int>("complianceRequestType")
                val callback = call.argument<Compliance.ResultCallback>("callback")

                if (context != null && supportFragmentManager != null && complianceRequestType != null && callback != null)
                    compliance.initComplianceRequest(context, supportFragmentManager,complianceRequestType,callback)
            }
        }
    }
}
