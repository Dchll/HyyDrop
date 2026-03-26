package com.example.hyy_drop

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.net.wifi.WifiManager
import android.os.Bundle
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.ResultReceiver
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var multicastLock: WifiManager.MulticastLock? = null
    private val networkChannel = "hyy_drop/network"
    private val liveUpdateChannel = "hyy_drop/live_update"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            networkChannel,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "acquireMulticastLock" -> {
                    result.success(acquireMulticastLock())
                }
                "releaseMulticastLock" -> {
                    releaseMulticastLock()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            liveUpdateChannel,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "syncTransferLiveUpdate" -> {
                    val payload = TransferNotificationPayload.fromMethodCall(call)
                    if (payload == null) {
                        result.error("invalid_args", "Missing live update payload", null)
                    } else {
                        val receiver = object : ResultReceiver(Handler(Looper.getMainLooper())) {
                            override fun onReceiveResult(resultCode: Int, resultData: Bundle?) {
                                if (resultCode == TransferForegroundService.RESULT_SYNC_OK) {
                                    result.success(true)
                                    return
                                }

                                result.success(false)
                            }
                        }

                        try {
                            ContextCompat.startForegroundService(
                                applicationContext,
                                TransferForegroundService.createSyncIntent(
                                    applicationContext,
                                    payload,
                                    receiver,
                                ),
                            )
                        } catch (error: Throwable) {
                            result.success(false)
                        }
                    }
                }
                "completeTransferLiveUpdate" -> {
                    val payload = TransferNotificationPayload.fromMethodCall(call)
                    if (payload == null) {
                        result.error("invalid_args", "Missing live update payload", null)
                    } else {
                        applicationContext.startService(
                            TransferForegroundService.createCompleteIntent(
                                applicationContext,
                                payload,
                            ),
                        )
                        result.success(null)
                    }
                }
                "failTransferLiveUpdate" -> {
                    val payload = TransferNotificationPayload.fromMethodCall(call)
                    if (payload == null) {
                        result.error("invalid_args", "Missing live update payload", null)
                    } else {
                        applicationContext.startService(
                            TransferForegroundService.createFailIntent(
                                applicationContext,
                                payload,
                            ),
                        )
                        result.success(null)
                    }
                }
                "stopTransferLiveUpdate" -> {
                    applicationContext.startService(
                        TransferForegroundService.createCancelIntent(applicationContext),
                    )
                    result.success(null)
                }
                "areNotificationsEnabled" -> {
                    result.success(
                        NotificationManagerCompat.from(applicationContext)
                            .areNotificationsEnabled(),
                    )
                }
                "canPostPromotedNotifications" -> {
                    result.success(canPostPromotedNotifications())
                }
                "openPromotedNotificationSettings" -> {
                    openPromotedNotificationSettings()
                    result.success(null)
                }
                "previewShortCriticalTextSegments" -> {
                    val text = (call.arguments as? Map<*, *>)?.get("text") as? String
                    result.success(ShortCriticalTextSegmenter.segment(text))
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        releaseMulticastLock()
        super.onDestroy()
    }

    private fun acquireMulticastLock(): Boolean {
        val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as? WifiManager
            ?: return false

        val lock = multicastLock ?: wifiManager.createMulticastLock("hyy_drop_discovery").apply {
            setReferenceCounted(false)
            multicastLock = this
        }

        if (!lock.isHeld) {
            lock.acquire()
        }

        return lock.isHeld
    }

    private fun releaseMulticastLock() {
        multicastLock?.let { lock ->
            if (lock.isHeld) {
                lock.release()
            }
        }
    }

    private fun canPostPromotedNotifications(): Boolean {
        if (!NotificationManagerCompat.from(applicationContext).areNotificationsEnabled()) {
            return false
        }

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.BAKLAVA) {
            return true
        }

        return applicationContext
            .getSystemService(NotificationManager::class.java)
            .canPostPromotedNotifications()
    }

    private fun openPromotedNotificationSettings() {
        val intent = Intent(
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.BAKLAVA) {
                Settings.ACTION_APP_NOTIFICATION_PROMOTION_SETTINGS
            } else {
                Settings.ACTION_APP_NOTIFICATION_SETTINGS
            },
        ).apply {
            putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

        startActivity(intent)
    }
}
