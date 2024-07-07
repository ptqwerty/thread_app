import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sms_service.dart';
import '../models/sms_message.dart';

class ThreadView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messages')),
      body: Consumer<SmsService>(
        builder: (context, smsService, child) {
          return ListView.builder(
            itemCount: smsService.messages.length,
            itemBuilder: (context, index) {
              final message = smsService.messages[index];
              return buildMessageTile(context, message, smsService);
            },
          );
        },
      ),
    );
  }

  Widget buildMessageTile(BuildContext context, SmsMessage message, SmsService smsService) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(message.sender),
            subtitle: Text(message.body),
            trailing: Text(message.timestamp.toString()),
            onTap: () => showReplyInput(context, message, smsService),
          ),
          ...message.replies.map((reply) => Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: ListTile(
              title: Text(reply.sender),
              subtitle: Text(reply.body),
              trailing: Text(reply.timestamp.toString()),
            ),
          )).toList(),
        ],
      ),
    );
  }

  void showReplyInput(BuildContext context, SmsMessage message, SmsService smsService) {
    TextEditingController replyController = TextEditingController();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true, // This ensures the sheet adjusts to keyboard
        builder: (BuildContext context) {
            return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom // Adjust padding to keyboard
                ),
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                    autofocus: true, // Focus the text field automatically
                                    controller: replyController,
                                    decoration: InputDecoration(labelText: 'Reply'),
                                ),
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                                child: ElevatedButton(
                                    onPressed: () {
                                        if (replyController.text.isNotEmpty) {
                                            smsService.addReply(message.id, replyController.text);
                                            Navigator.pop(context); // Close the modal after sending
                                        }
                                    },
                                    child: Text('Send Reply'),
                                ),
                            ),
                        ],
                    ),
                ),
            );
        }
    );
  }

}
