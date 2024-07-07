import 'sms_message.dart';

class Thread {
  final String id;
  final String title;
  final List<SmsMessage> messages;

  Thread({required this.id, required this.title, required this.messages});
}
