package com.example.greate_word

import android.app.ActivityManager
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat

class ForegroundService : Service() {

    private var unlockReceiver: BroadcastReceiver? = null

    override fun onCreate() {
        super.onCreate()

        // 포그라운드 서비스로 설정
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "default", "Default", NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)
        }

        val notification = NotificationCompat.Builder(this, "default")
            .setContentTitle("App is running in the background")
            .setContentText("This is a foreground service.")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .build()

        startForeground(1, notification)  // 포그라운드 서비스 시작

        // 잠금 해제 이벤트 리시버 등록
        unlockReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent?.action == Intent.ACTION_USER_PRESENT) {
                    Log.d("UnlockReceiver", "🔓 핸드폰 잠금 해제 감지됨! 앱 실행")

                    val activityManager = context?.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
                    val runningTasks = activityManager.appTasks

                    if (runningTasks.isNotEmpty()) {
                        // 앱이 실행 중이면 최상위로 가져옴
                        val moveIntent = Intent(context, MainActivity::class.java)
                        moveIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
                        context.startActivity(moveIntent)
                    } else {
                        // 앱이 실행 중이 아니면 새로 실행
                        val launchIntent = context?.packageManager?.getLaunchIntentForPackage(context.packageName)
                        launchIntent?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                        context?.startActivity(launchIntent)
                    }
                }
            }
        }

        // 잠금 해제 이벤트 리시버 등록
        val unlockFilter = IntentFilter(Intent.ACTION_USER_PRESENT)
        registerReceiver(unlockReceiver, unlockFilter)
    }

    override fun onDestroy() {
        super.onDestroy()
        // 리시버 해제
        unregisterReceiver(unlockReceiver)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_STICKY  // 서비스가 종료되지 않도록 설정
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}
