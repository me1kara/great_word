package com.example.greate_word

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class ForegroundServiceManager(private val context: Context) {

    fun startForegroundService() {
        val intent = Intent(context, ForegroundService::class.java)
        context.startForegroundService(intent)
        savePreference(true)
    }

    fun stopForegroundService() {
        val intent = Intent(context, ForegroundService::class.java)
        context.stopService(intent)
        savePreference(false)
    }

    private fun savePreference(isEnabled: Boolean) {
        val prefs = context.getSharedPreferences("my_prefs", Context.MODE_PRIVATE)
        prefs.edit().putBoolean("foregroundEnabled", isEnabled).apply()
    }
}
