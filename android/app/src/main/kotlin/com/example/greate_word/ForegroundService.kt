package com.example.greate_word

import android.app.*
import android.content.*
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat

class ForegroundService : Service() {

    private var unlockReceiver: BroadcastReceiver? = null

    override fun onCreate() {
        super.onCreate()

        // 알림 채널 생성 (Android 8.0 이상 필요)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "default", "Foreground Service",
                NotificationManager.IMPORTANCE_LOW // 중요도를 낮춤 (알림 최소화)
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)
        }

        // 포그라운드 서비스 실행을 위한 알림 생성
        val notification = NotificationCompat.Builder(this, "default")
            .setContentTitle("앱이 백그라운드에서 실행 중")
            .setContentText("잠금 해제 시 앱을 실행합니다.")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .build()

        startForeground(1, notification)

        // 잠금 해제 감지 리시버 등록
        unlockReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent?.action == Intent.ACTION_USER_PRESENT) {
                    Log.d("ForegroundService", "🔓 핸드폰 잠금 해제 감지됨! 앱 실행")

                    context?.let {
                        val launchIntent = it.packageManager?.getLaunchIntentForPackage(it.packageName)
                        launchIntent?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                        it.startActivity(launchIntent)
                    }
                }
            }
        }

        // 리시버 등록
        val unlockFilter = IntentFilter(Intent.ACTION_USER_PRESENT)
        registerReceiver(unlockReceiver, unlockFilter)
    }

    override fun onDestroy() {
        super.onDestroy()
        unlockReceiver?.let {
            unregisterReceiver(it)
            unlockReceiver = null
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_STICKY  // 시스템이 종료해도 다시 시작됨
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}
