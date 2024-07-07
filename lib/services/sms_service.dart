import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/sms_message.dart';
import 'package:flutter/foundation.dart';

class SmsService with ChangeNotifier {
  static const platform = MethodChannel('com.example.thread_app/sms');

  List<SmsMessage> _messages = [];

  List<SmsMessage> get messages => _messages;

  SmsService() {
    _initialize();
  }

  Future<void> _initialize() async {
    await getSmsMessages();
    platform.setMethodCallHandler(_handleIncomingMessage);
  }

  Future<void> getSmsMessages() async {
    if (await Permission.sms.request().isGranted) {
      final List<dynamic> messages = await platform.invokeMethod('getSmsMessages');
      _messages = messages.map((e) => SmsMessage.fromMap(Map<String, dynamic>.from(e))).toList();
      notifyListeners();
    }
  }

  Future<void> _handleIncomingMessage(MethodCall call) async {
    if (call.method == 'newSmsReceived') {
      final dynamic message = call.arguments;
      final SmsMessage smsMessage = SmsMessage.fromMap(Map<String, dynamic>.from(message));
      _messages.insert(0, smsMessage);
      notifyListeners();
    }
  }

  void addReply(String messageId, String body) {
    final int index = _messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      final reply = SmsMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        body: body,
        sender: "Me", // or dynamically assign the sender
        timestamp: DateTime.now(),
        replies: [] // Replies start with no nested replies
      );
      _messages[index].replies.add(reply);
      notifyListeners();
    }
  }
}
