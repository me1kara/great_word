package com.example.greate_word

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import io.flutter.embedding.android.FlutterActivity

class ForegroundServiceManager(private val context: Context) {

    fun startForegroundService() {
        val intent = Intent(context, ForegroundService::class.java)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(intent) // 수정된 부분
        } else {
            context.startService(intent) // 수정된 부분
        }
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
