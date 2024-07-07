class SmsMessage {
  final String id;
  final String body;
  final String sender;
  final DateTime timestamp;
  final List<SmsMessage> replies;

  SmsMessage({
    required this.id,
    required this.body,
    required this.sender,
    required this.timestamp,
    this.replies = const [],
  });

  factory SmsMessage.fromMap(Map<String, dynamic> map) {
    List<SmsMessage> replies = [];
    if (map['replies'] != null) {
      replies = (map['replies'] as List<dynamic>).map((e) => SmsMessage.fromMap(e as Map<String, dynamic>)).toList();
    }
    return SmsMessage(
      id: map['id'] as String? ?? '',
      body: map['body'] as String? ?? '',
      sender: map['sender'] as String? ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int? ?? 0),
      replies: replies,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'body': body,
      'sender': sender,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'replies': replies.map((e) => e.toMap()).toList(),
    };
  }
}
