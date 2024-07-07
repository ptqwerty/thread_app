package com.example.thread_app

import android.database.Cursor
import android.net.Uri
import android.telephony.SmsManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.thread_app/sms"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getSmsMessages" -> {
                    val messages = getSmsMessages()
                    result.success(messages)
                }
                "sendSms" -> {
                    val phoneNumber = call.argument<String>("phoneNumber")
                    val message = call.argument<String>("message")
                    if (phoneNumber != null && message != null) {
                        sendSms(phoneNumber, message)
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENTS", "Phone number or message is null", null)
                    }
                }
                else -> result.notImplemented()
            }
        }

        // Set the method channel for SmsReceiver
        SmsReceiver.setMethodChannel(methodChannel)
    }

    private fun getSmsMessages(): List<Map<String, Any>> {
        val messages = mutableListOf<Map<String, Any>>()
        val uri: Uri = Uri.parse("content://sms")
        val cursor: Cursor? = contentResolver.query(uri, null, null, null, null)

        cursor?.use {
            while (it.moveToNext()) {
                val message = mapOf(
                    "id" to it.getString(it.getColumnIndex("_id")),
                    "body" to it.getString(it.getColumnIndex("body")),
                    "sender" to it.getString(it.getColumnIndex("address")),
                    "timestamp" to it.getLong(it.getColumnIndex("date"))
                )
                messages.add(message)
            }
        }
        return messages
    }

    private fun sendSms(phoneNumber: String, message: String) {
        val smsManager: SmsManager = SmsManager.getDefault()
        smsManager.sendTextMessage(phoneNumber, null, message, null, null)
    }
}
