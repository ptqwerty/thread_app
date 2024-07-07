package com.example.thread_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.telephony.SmsMessage
import io.flutter.plugin.common.MethodChannel

class SmsReceiver : BroadcastReceiver() {
    companion object {
        private var channel: MethodChannel? = null

        fun setMethodChannel(methodChannel: MethodChannel) {
            channel = methodChannel
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        val bundle: Bundle? = intent.extras
        bundle?.let {
            val pdus = it.get("pdus") as Array<*>
            for (pdu in pdus) {
                val smsMessage = SmsMessage.createFromPdu(pdu as ByteArray)
                val sender = smsMessage.displayOriginatingAddress
                val messageBody = smsMessage.messageBody
                val timestamp = smsMessage.timestampMillis

                // Send the incoming message to Flutter
                channel?.invokeMethod("newSmsReceived", createMessageMap(sender, messageBody, timestamp))
            }
        }
    }

    private fun createMessageMap(sender: String, body: String, timestamp: Long): Map<String, Any> {
        return mapOf(
            "id" to timestamp.toString(), // Use timestamp as a unique ID
            "body" to body,
            "sender" to sender,
            "timestamp" to timestamp
        )
    }
}
