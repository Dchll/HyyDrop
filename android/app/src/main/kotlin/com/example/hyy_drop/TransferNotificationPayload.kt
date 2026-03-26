package com.example.hyy_drop

import android.content.Intent
import io.flutter.plugin.common.MethodCall

data class TransferNotificationPayload(
    val taskId: String,
    val title: String,
    val body: String,
    val subText: String?,
    val progress: Int?,
    val shortCriticalText: String?,
    val shortTextRotationSeconds: Int?,
    val successToastMessage: String?,
    val styleType: String?,
    val callType: String?,
    val callIsVideo: Boolean?,
    val metricPrimaryLabel: String?,
    val metricPrimaryValue: String?,
    val metricSecondaryLabel: String?,
    val metricSecondaryValue: String?,
    val metricTertiaryLabel: String?,
    val metricTertiaryValue: String?,
) {
    fun writeToIntent(intent: Intent) {
        intent.putExtra(EXTRA_TASK_ID, taskId)
        intent.putExtra(EXTRA_TITLE, title)
        intent.putExtra(EXTRA_BODY, body)
        intent.putExtra(EXTRA_SUB_TEXT, subText)
        intent.putExtra(EXTRA_PROGRESS, progress)
        intent.putExtra(EXTRA_SHORT_CRITICAL_TEXT, shortCriticalText)
        intent.putExtra(EXTRA_SHORT_TEXT_ROTATION_SECONDS, shortTextRotationSeconds)
        intent.putExtra(EXTRA_SUCCESS_TOAST_MESSAGE, successToastMessage)
        intent.putExtra(EXTRA_STYLE_TYPE, styleType)
        intent.putExtra(EXTRA_CALL_TYPE, callType)
        intent.putExtra(EXTRA_CALL_IS_VIDEO, callIsVideo)
        intent.putExtra(EXTRA_METRIC_PRIMARY_LABEL, metricPrimaryLabel)
        intent.putExtra(EXTRA_METRIC_PRIMARY_VALUE, metricPrimaryValue)
        intent.putExtra(EXTRA_METRIC_SECONDARY_LABEL, metricSecondaryLabel)
        intent.putExtra(EXTRA_METRIC_SECONDARY_VALUE, metricSecondaryValue)
        intent.putExtra(EXTRA_METRIC_TERTIARY_LABEL, metricTertiaryLabel)
        intent.putExtra(EXTRA_METRIC_TERTIARY_VALUE, metricTertiaryValue)
    }

    companion object {
        private const val EXTRA_TASK_ID = "transfer.task_id"
        private const val EXTRA_TITLE = "transfer.title"
        private const val EXTRA_BODY = "transfer.body"
        private const val EXTRA_SUB_TEXT = "transfer.sub_text"
        private const val EXTRA_PROGRESS = "transfer.progress"
        private const val EXTRA_SHORT_CRITICAL_TEXT = "transfer.short_critical_text"
        private const val EXTRA_SHORT_TEXT_ROTATION_SECONDS = "transfer.short_text_rotation_seconds"
        private const val EXTRA_SUCCESS_TOAST_MESSAGE = "transfer.success_toast_message"
        private const val EXTRA_STYLE_TYPE = "transfer.style_type"
        private const val EXTRA_CALL_TYPE = "transfer.call_type"
        private const val EXTRA_CALL_IS_VIDEO = "transfer.call_is_video"
        private const val EXTRA_METRIC_PRIMARY_LABEL = "transfer.metric_primary_label"
        private const val EXTRA_METRIC_PRIMARY_VALUE = "transfer.metric_primary_value"
        private const val EXTRA_METRIC_SECONDARY_LABEL = "transfer.metric_secondary_label"
        private const val EXTRA_METRIC_SECONDARY_VALUE = "transfer.metric_secondary_value"
        private const val EXTRA_METRIC_TERTIARY_LABEL = "transfer.metric_tertiary_label"
        private const val EXTRA_METRIC_TERTIARY_VALUE = "transfer.metric_tertiary_value"

        fun fromMethodCall(call: MethodCall): TransferNotificationPayload? {
            val arguments = call.arguments as? Map<*, *> ?: return null
            return fromMap(arguments)
        }

        fun fromIntent(intent: Intent): TransferNotificationPayload? {
            val taskId = intent.getStringExtra(EXTRA_TASK_ID) ?: return null
            val title = intent.getStringExtra(EXTRA_TITLE) ?: return null
            val body = intent.getStringExtra(EXTRA_BODY) ?: return null
            return TransferNotificationPayload(
                taskId = taskId,
                title = title,
                body = body,
                subText = intent.getStringExtra(EXTRA_SUB_TEXT),
                progress = intent.getIntExtra(EXTRA_PROGRESS, -1).takeIf { it >= 0 },
                shortCriticalText = intent.getStringExtra(EXTRA_SHORT_CRITICAL_TEXT),
                shortTextRotationSeconds = intent.getIntExtra(EXTRA_SHORT_TEXT_ROTATION_SECONDS, -1)
                    .takeIf { it >= 1 },
                successToastMessage = intent.getStringExtra(EXTRA_SUCCESS_TOAST_MESSAGE),
                styleType = intent.getStringExtra(EXTRA_STYLE_TYPE),
                callType = intent.getStringExtra(EXTRA_CALL_TYPE),
                callIsVideo = intent.extras?.takeIf { it.containsKey(EXTRA_CALL_IS_VIDEO) }
                    ?.getBoolean(EXTRA_CALL_IS_VIDEO),
                metricPrimaryLabel = intent.getStringExtra(EXTRA_METRIC_PRIMARY_LABEL),
                metricPrimaryValue = intent.getStringExtra(EXTRA_METRIC_PRIMARY_VALUE),
                metricSecondaryLabel = intent.getStringExtra(EXTRA_METRIC_SECONDARY_LABEL),
                metricSecondaryValue = intent.getStringExtra(EXTRA_METRIC_SECONDARY_VALUE),
                metricTertiaryLabel = intent.getStringExtra(EXTRA_METRIC_TERTIARY_LABEL),
                metricTertiaryValue = intent.getStringExtra(EXTRA_METRIC_TERTIARY_VALUE),
            )
        }

        private fun fromMap(arguments: Map<*, *>): TransferNotificationPayload? {
            val taskId = arguments["taskId"] as? String ?: return null
            val title = arguments["title"] as? String ?: return null
            val body = arguments["body"] as? String ?: return null
            val progress = when (val value = arguments["progress"]) {
                is Int -> value
                is Long -> value.toInt()
                is Double -> value.toInt()
                else -> null
            }

            return TransferNotificationPayload(
                taskId = taskId,
                title = title,
                body = body,
                subText = arguments["subText"] as? String,
                progress = progress,
                shortCriticalText = arguments["shortCriticalText"] as? String,
                shortTextRotationSeconds = when (val value = arguments["shortTextRotationSeconds"]) {
                    is Int -> value
                    is Long -> value.toInt()
                    is Double -> value.toInt()
                    else -> null
                },
                successToastMessage = arguments["successToastMessage"] as? String,
                styleType = arguments["styleType"] as? String,
                callType = arguments["callType"] as? String,
                callIsVideo = arguments["callIsVideo"] as? Boolean,
                metricPrimaryLabel = arguments["metricPrimaryLabel"] as? String,
                metricPrimaryValue = arguments["metricPrimaryValue"] as? String,
                metricSecondaryLabel = arguments["metricSecondaryLabel"] as? String,
                metricSecondaryValue = arguments["metricSecondaryValue"] as? String,
                metricTertiaryLabel = arguments["metricTertiaryLabel"] as? String,
                metricTertiaryValue = arguments["metricTertiaryValue"] as? String,
            )
        }
    }
}
