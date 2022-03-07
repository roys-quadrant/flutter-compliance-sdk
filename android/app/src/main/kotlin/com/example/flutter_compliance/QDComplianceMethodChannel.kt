package com.example.compliance

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

