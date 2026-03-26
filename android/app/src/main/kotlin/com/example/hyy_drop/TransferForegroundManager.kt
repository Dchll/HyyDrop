package com.example.hyy_drop

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.Person

class TransferForegroundManager(
    private val context: Context,
) {
    private val nm = NotificationManagerCompat.from(context)

    fun ensureChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return
        }

        val channel = NotificationChannel(
            CHANNEL_ID,
            "File Transfer",
            NotificationManager.IMPORTANCE_DEFAULT,
        ).apply {
            description = "LAN file transfer progress"
            setShowBadge(false)
        }

        context.getSystemService(NotificationManager::class.java)
            .createNotificationChannel(channel)
    }

    fun buildOngoing(payload: TransferNotificationPayload): Notification {
        return when (payload.styleType) {
            STYLE_BIG_TEXT -> buildBigTextNotification(payload)
            STYLE_CALL -> buildCallNotification(payload)
            STYLE_PROGRESS -> buildProgressNotification(payload)
            STYLE_METRIC -> buildMetricNotification(payload)
            else -> buildStandardNotification(payload)
        }
    }

    fun showOngoing(id: Int, payload: TransferNotificationPayload) {
        ensureChannel()
        nm.notify(id, buildOngoing(payload))
    }

    fun showCompleted(id: Int, payload: TransferNotificationPayload) {
        ensureChannel()
        nm.notify(
            id,
            NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(payload.title)
                .setContentText(payload.body)
                .setSubText(payload.subText)
                .setContentIntent(createLaunchIntent())
                .setAutoCancel(true)
                .build(),
        )
    }

    fun showFailed(id: Int, payload: TransferNotificationPayload) {
        ensureChannel()
        nm.notify(
            id,
            NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(payload.title)
                .setContentText(payload.body)
                .setSubText(payload.subText)
                .setContentIntent(createLaunchIntent())
                .setAutoCancel(true)
                .build(),
        )
    }

    fun cancel(id: Int) {
        nm.cancel(id)
    }

    private fun buildStandardNotification(payload: TransferNotificationPayload): Notification {
        val builder = baseBuilder(payload)
            .setCategory(NotificationCompat.CATEGORY_PROGRESS)

        payload.progress?.let { progress ->
            builder.setProgress(100, progress.coerceIn(0, 100), false)
        }

        return builder.build()
    }

    private fun buildBigTextNotification(payload: TransferNotificationPayload): Notification {
        val style = NotificationCompat.BigTextStyle()
            .setBigContentTitle(payload.title)
            .bigText(payload.body)

        payload.subText
            ?.takeIf { it.isNotBlank() }
            ?.let(style::setSummaryText)

        return baseBuilder(payload)
            .setCategory(NotificationCompat.CATEGORY_MESSAGE)
            .setStyle(style)
            .build()
    }

    private fun buildCallNotification(payload: TransferNotificationPayload): Notification {
        val actionIntent = createLaunchIntent() ?: return buildStandardNotification(payload)
        val person = Person.Builder()
            .setName(payload.title.ifBlank { "Caller" })
            .build()

        val style = when (payload.callType) {
            CALL_TYPE_ONGOING -> NotificationCompat.CallStyle.forOngoingCall(
                person,
                actionIntent,
            )
            CALL_TYPE_SCREENING -> NotificationCompat.CallStyle.forScreeningCall(
                person,
                actionIntent,
                actionIntent,
            )
            else -> NotificationCompat.CallStyle.forIncomingCall(
                person,
                actionIntent,
                actionIntent,
            )
        }.setIsVideo(payload.callIsVideo == true)

        payload.subText
            ?.takeIf { it.isNotBlank() }
            ?.let(style::setVerificationText)

        return baseBuilder(payload)
            .setCategory(NotificationCompat.CATEGORY_CALL)
            .setStyle(style)
            .build()
    }

    private fun buildProgressNotification(payload: TransferNotificationPayload): Notification {
        val style = NotificationCompat.ProgressStyle()

        val progress = payload.progress?.coerceIn(0, 100)
        if (progress == null) {
            style.setProgressIndeterminate(true)
        } else {
            style.setProgress(progress)
        }

        return baseBuilder(payload)
            .setCategory(NotificationCompat.CATEGORY_PROGRESS)
            .setStyle(style)
            .build()
    }

    private fun buildMetricNotification(payload: TransferNotificationPayload): Notification {
        val fallbackBuilder = baseBuilder(payload)
            .setCategory(NotificationCompat.CATEGORY_STATUS)

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.BAKLAVA) {
            fallbackBuilder.setStyle(
                NotificationCompat.BigTextStyle()
                    .setBigContentTitle(payload.title)
                    .bigText(buildMetricFallbackBody(payload)),
            )
            return fallbackBuilder.build()
        }

        return runCatching {
            val metricStyleClass = Class.forName("android.app.Notification\$MetricStyle")
            val metricClass = Class.forName("android.app.Notification\$Metric")
            val metricValueClass = Class.forName("android.app.Notification\$Metric\$MetricValue")
            val fixedTextClass = Class.forName("android.app.Notification\$Metric\$FixedText")

            val style = metricStyleClass.getConstructor().newInstance() as Notification.Style
            val metricCtor = metricClass.getConstructor(metricValueClass, CharSequence::class.java)
            val fixedTextCtor = fixedTextClass.getConstructor(CharSequence::class.java)
            val addMetric = metricStyleClass.getMethod("addMetric", metricClass)

            metricEntries(payload).forEach { (label, value) ->
                val fixedText = fixedTextCtor.newInstance(value)
                val metric = metricCtor.newInstance(fixedText, label)
                addMetric.invoke(style, metric)
            }

            basePlatformBuilder(payload, Notification.CATEGORY_STATUS)
                .setStyle(style)
                .build()
        }.getOrElse {
            fallbackBuilder.setStyle(
                NotificationCompat.BigTextStyle()
                    .setBigContentTitle(payload.title)
                    .bigText(buildMetricFallbackBody(payload)),
            )
            fallbackBuilder.build()
        }
    }

    private fun baseBuilder(payload: TransferNotificationPayload): NotificationCompat.Builder {
        val builder = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(payload.title)
            .setContentText(payload.body)
            .setSubText(payload.subText)
            .setContentIntent(createLaunchIntent())
            .setOnlyAlertOnce(true)
            .setOngoing(true)
            .setRequestPromotedOngoing(true)
            .setSilent(true)

        payload.shortCriticalText
            ?.takeIf { it.isNotBlank() }
            ?.let(builder::setShortCriticalText)

        return builder
    }

    private fun basePlatformBuilder(
        payload: TransferNotificationPayload,
        category: String,
    ): Notification.Builder {
        return Notification.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(payload.title)
            .setContentText(payload.body)
            .setSubText(payload.subText)
            .setContentIntent(createLaunchIntent())
            .setOnlyAlertOnce(true)
            .setOngoing(true)
            .setCategory(category)
    }

    private fun buildMetricFallbackBody(payload: TransferNotificationPayload): String {
        val metricLines = metricEntries(payload)
            .map { (label, value) -> "$label: $value" }

        return buildList {
            payload.body.takeIf { it.isNotBlank() }?.let(::add)
            addAll(metricLines)
        }.joinToString("\n")
    }

    private fun metricEntries(payload: TransferNotificationPayload): List<Pair<String, String>> {
        return listOfNotNull(
            metricEntry(payload.metricPrimaryLabel, payload.metricPrimaryValue),
            metricEntry(payload.metricSecondaryLabel, payload.metricSecondaryValue),
            metricEntry(payload.metricTertiaryLabel, payload.metricTertiaryValue),
        )
    }

    private fun metricEntry(label: String?, value: String?): Pair<String, String>? {
        val safeLabel = label?.trim()
        val safeValue = value?.trim()
        if (safeLabel.isNullOrEmpty() || safeValue.isNullOrEmpty()) {
            return null
        }
        return safeLabel to safeValue
    }

    private fun createLaunchIntent(): PendingIntent? {
        val launchIntent = context.packageManager.getLaunchIntentForPackage(
            context.packageName,
        ) ?: return null

        return PendingIntent.getActivity(
            context,
            0,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    companion object {
        const val CHANNEL_ID = "transfer_live_update"
        const val STYLE_STANDARD = "standard"
        const val STYLE_BIG_TEXT = "big_text"
        const val STYLE_CALL = "call"
        const val STYLE_PROGRESS = "progress"
        const val STYLE_METRIC = "metric"

        const val CALL_TYPE_INCOMING = "incoming"
        const val CALL_TYPE_ONGOING = "ongoing"
        const val CALL_TYPE_SCREENING = "screening"
    }
}
