package com.example.flutter_compliance

import android.content.pm.PackageManager
import android.util.Log
import android.widget.Toast
import com.example.compliance.QDComplianceMethodChannel
import com.quadrant.sdk.compliance.core.Compliance
import com.quadrant.sdk.compliance.util.ConsentResult
import com.quadrant.sdk.compliance.util.PermissionUtil
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterFragmentActivity() {
    var complianceMethodChannel: QDComplianceMethodChannel? = null
    private val INTEGRATION_KEY = "55b1055d4eafb6c05fdcfa01bf9ff2f6"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        complianceMethodChannel = QDComplianceMethodChannel(this, this.supportFragmentManager, flutterEngine, INTEGRATION_KEY)

    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PermissionUtil.PERMISSION_ACCESS_LOCATION) {
            if (grantResults.size > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                openConsentForm()
            } else {
                Toast.makeText(this, "Location permission denied", Toast.LENGTH_LONG).show()
            }
        }
    }

    private fun openConsentForm() {
        complianceMethodChannel?.compliance?.let {
            it.openConsentFormIfNeeded(this, supportFragmentManager, object : Compliance.ConsentCallback {
                override fun onSuccess(consentResult: ConsentResult) {
                    Log.d("openConsentFormIfNeeded", consentResult.toString())
                    when (consentResult) {
                        ConsentResult.ccpaAccept -> {
                            //CCPA accept button clicked
                        }
                        ConsentResult.ccpaDecline -> {
                            //CCPA decline button clicked
                        }
                        ConsentResult.gdprAccept -> {
                            //GDPR accept button clicked
                        }
                        ConsentResult.gdprDecline -> {
                            //GDPR decline button clicked
                        }
                        ConsentResult.notConsent -> {
                            //user location no need for consent
                        }
                    }
                }

                override fun onError(result: String) {
                    Log.d("openConsentFormIfNeeded", result)
                }
            })
        }

    }

}