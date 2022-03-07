package com.example.flutter_compliance

import android.app.Application
import android.util.Log
import com.quadrant.sdk.compliance.core.Compliance

class Application: Application() {

    private val integrationKey = "55b1055d4eafb6c05fdcfa01bf9ff2f6"
    override fun onCreate() {
        super.onCreate()
        Log.d("application", "application created")

    }
}