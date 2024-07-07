import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import 'models/sms_message.dart';
import 'services/sms_service.dart';
import 'ui/thread_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SmsService(),
      child: MaterialApp(
        title: 'Thread App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ThreadView(),
      ),
    );
  }
}
