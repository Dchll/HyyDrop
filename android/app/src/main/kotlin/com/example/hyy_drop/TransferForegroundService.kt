package com.example.hyy_drop

import android.app.Service
import android.os.Bundle
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.ResultReceiver
import android.widget.Toast
import androidx.core.app.ServiceCompat

class TransferForegroundService : Service() {
    private lateinit var manager: TransferForegroundManager
    private val rotationHandler = Handler(Looper.getMainLooper())
    private var rotationRunnable: Runnable? = null
    private var rotatingPayload: TransferNotificationPayload? = null
    private var rotatingSegments: List<String> = emptyList()
    private var rotatingNotificationId: Int? = null
    private var rotatingIntervalMs: Long = DEFAULT_SHORT_TEXT_ROTATION_MS
    private var currentSegmentIndex = 0

    override fun onCreate() {
        super.onCreate()
        manager = TransferForegroundManager(this)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action ?: return START_NOT_STICKY
        val resultReceiver = intent.resultReceiverCompat(EXTRA_RESULT_RECEIVER)
        val notificationId = intent.getIntExtra(
            EXTRA_NOTIFICATION_ID,
            DEFAULT_NOTIFICATION_ID,
        )

        when (action) {
            ACTION_SYNC -> {
                val payload = TransferNotificationPayload.fromIntent(intent)
                if (payload == null) {
                    resultReceiver?.send(RESULT_SYNC_FAILED, failureBundle("Missing live update payload"))
                    return START_NOT_STICKY
                }
                handleSync(notificationId, payload, resultReceiver)
            }
            ACTION_COMPLETE -> {
                val payload = TransferNotificationPayload.fromIntent(intent)
                    ?: return START_NOT_STICKY
                handleComplete(notificationId, payload)
            }
            ACTION_FAIL -> {
                val payload = TransferNotificationPayload.fromIntent(intent)
                    ?: return START_NOT_STICKY
                handleFail(notificationId, payload)
            }
            ACTION_CANCEL -> handleCancel(notificationId)
        }

        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        stopRotation()
        super.onDestroy()
    }

    private fun handleSync(
        notificationId: Int,
        payload: TransferNotificationPayload,
        resultReceiver: ResultReceiver?,
    ) {
        runCatching {
            manager.ensureChannel()
            val segments = ShortCriticalTextSegmenter.segment(payload.shortCriticalText)
            val intervalMs = payload.shortTextRotationSeconds
                ?.coerceIn(1, 10)
                ?.times(1000L)
                ?: DEFAULT_SHORT_TEXT_ROTATION_MS
            val shouldPreserveRotation =
                notificationId == rotatingNotificationId &&
                    segments == rotatingSegments &&
                    segments.isNotEmpty() &&
                    intervalMs == rotatingIntervalMs
            val effectivePayload = if (shouldPreserveRotation) {
                payload.copy(shortCriticalText = segments[currentSegmentIndex])
            } else {
                currentSegmentIndex = 0
                payload.copy(shortCriticalText = segments.firstOrNull() ?: payload.shortCriticalText)
            }
            updateForegroundNotification(notificationId, effectivePayload)

            if (segments.size > 1) {
                rotatingNotificationId = notificationId
                rotatingPayload = payload
                rotatingSegments = segments
                rotatingIntervalMs = intervalMs
                if (!shouldPreserveRotation || rotationRunnable == null) {
                    startRotation()
                }
            } else {
                stopRotation()
            }

            payload.successToastMessage
                ?.takeIf { it.isNotBlank() }
                ?.let { message ->
                    Toast.makeText(applicationContext, message, Toast.LENGTH_SHORT).show()
                }
        }.onSuccess {
            resultReceiver?.send(RESULT_SYNC_OK, Bundle.EMPTY)
        }.onFailure { error ->
            resultReceiver?.send(
                RESULT_SYNC_FAILED,
                failureBundle(error.message ?: "Failed to sync live update"),
            )
        }
    }

    private fun handleComplete(
        notificationId: Int,
        payload: TransferNotificationPayload,
    ) {
        stopRotation()
        detachForeground(false)
        manager.showCompleted(notificationId, payload)
        stopSelf()
    }

    private fun handleFail(
        notificationId: Int,
        payload: TransferNotificationPayload,
    ) {
        stopRotation()
        detachForeground(false)
        manager.showFailed(notificationId, payload)
        stopSelf()
    }

    private fun handleCancel(notificationId: Int) {
        stopRotation()
        detachForeground(true)
        manager.cancel(notificationId)
        stopSelf()
    }

    private fun startRotation() {
        cancelRotationCallbacks()
        if (rotatingSegments.size <= 1) {
            return
        }

        rotationRunnable = object : Runnable {
            override fun run() {
                val notificationId = rotatingNotificationId ?: return
                val payload = rotatingPayload ?: return
                val segments = rotatingSegments
                if (segments.size <= 1) {
                    return
                }

                currentSegmentIndex = (currentSegmentIndex + 1) % segments.size
                val segment = segments[currentSegmentIndex]
                updateForegroundNotification(
                    notificationId,
                    payload.copy(shortCriticalText = segment),
                )
                rotationHandler.postDelayed(this, rotatingIntervalMs)
            }
        }.also { runnable ->
            rotationHandler.postDelayed(runnable, rotatingIntervalMs)
        }
    }

    private fun stopRotation() {
        cancelRotationCallbacks()
        rotatingPayload = null
        rotatingSegments = emptyList()
        rotatingNotificationId = null
        rotatingIntervalMs = DEFAULT_SHORT_TEXT_ROTATION_MS
        currentSegmentIndex = 0
    }

    private fun cancelRotationCallbacks() {
        rotationRunnable?.let(rotationHandler::removeCallbacks)
        rotationRunnable = null
    }

    private fun updateForegroundNotification(
        notificationId: Int,
        payload: TransferNotificationPayload,
    ) {
        val notification = manager.buildOngoing(payload)
        val serviceType = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC
        } else {
            0
        }

        ServiceCompat.startForeground(
            this,
            notificationId,
            notification,
            serviceType,
        )
    }

    private fun detachForeground(removeNotification: Boolean) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            stopForeground(
                if (removeNotification) {
                    STOP_FOREGROUND_REMOVE
                } else {
                    STOP_FOREGROUND_DETACH
                },
            )
            return
        }

        @Suppress("DEPRECATION")
        stopForeground(removeNotification)
    }

    companion object {
        private const val ACTION_SYNC = "com.example.hyy_drop.transfer.SYNC"
        private const val ACTION_COMPLETE = "com.example.hyy_drop.transfer.COMPLETE"
        private const val ACTION_FAIL = "com.example.hyy_drop.transfer.FAIL"
        private const val ACTION_CANCEL = "com.example.hyy_drop.transfer.CANCEL"
        private const val EXTRA_NOTIFICATION_ID = "notificationId"
        private const val EXTRA_RESULT_RECEIVER = "resultReceiver"
        private const val EXTRA_ERROR_MESSAGE = "errorMessage"
        private const val DEFAULT_NOTIFICATION_ID = 41041
        private const val DEFAULT_SHORT_TEXT_ROTATION_MS = 5000L
        const val RESULT_SYNC_OK = 1
        const val RESULT_SYNC_FAILED = 2

        fun createSyncIntent(
            context: Context,
            payload: TransferNotificationPayload,
            resultReceiver: ResultReceiver? = null,
        ): Intent {
            return Intent(context, TransferForegroundService::class.java).apply {
                action = ACTION_SYNC
                putExtra(EXTRA_NOTIFICATION_ID, DEFAULT_NOTIFICATION_ID)
                putExtra(EXTRA_RESULT_RECEIVER, resultReceiver)
                payload.writeToIntent(this)
            }
        }

        fun createCompleteIntent(
            context: Context,
            payload: TransferNotificationPayload,
        ): Intent {
            return Intent(context, TransferForegroundService::class.java).apply {
                action = ACTION_COMPLETE
                putExtra(EXTRA_NOTIFICATION_ID, DEFAULT_NOTIFICATION_ID)
                payload.writeToIntent(this)
            }
        }

        fun createFailIntent(
            context: Context,
            payload: TransferNotificationPayload,
        ): Intent {
            return Intent(context, TransferForegroundService::class.java).apply {
                action = ACTION_FAIL
                putExtra(EXTRA_NOTIFICATION_ID, DEFAULT_NOTIFICATION_ID)
                payload.writeToIntent(this)
            }
        }

        fun createCancelIntent(context: Context): Intent {
            return Intent(context, TransferForegroundService::class.java).apply {
                action = ACTION_CANCEL
                putExtra(EXTRA_NOTIFICATION_ID, DEFAULT_NOTIFICATION_ID)
            }
        }

        fun failureBundle(message: String): Bundle {
            return Bundle().apply {
                putString(EXTRA_ERROR_MESSAGE, message)
            }
        }
    }
}

private fun Intent.resultReceiverCompat(key: String): ResultReceiver? {
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        getParcelableExtra(key, ResultReceiver::class.java)
    } else {
        @Suppress("DEPRECATION")
        getParcelableExtra(key)
    }
}
