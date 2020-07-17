import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notifications/model/message.dart';

class MessagingWidget extends StatefulWidget {
  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
            title: notification['title']+' onMessage',
            body: notification['body']
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        final notification = message['data'];

        setState(() {
          messages.add(Message(
            title: '$message',
            body: 'onResume'));
        });

        setState(() {
          messages.add(Message(
            title: 'onResume ${notification['title']}',
            body: 'onResume ${notification['body']}'
          ));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        

        setState(() {
          messages.add(Message(
            title: '$message',
            body: 'onLaunch'));
        });

        final notification = message['data'];
        setState(() {
          messages.add(Message(
            title: 'onLaunch ${notification['title']}',
            body: 'onLaunch ${notification['body']}'
          ));
        });
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true)
    );
  }

  @override
  Widget build(BuildContext context) => ListView(
    children: messages.map(buildMessage).toList(),
  );

  Widget buildMessage(Message message) => ListTile(
    title: Text(message.title),
    subtitle: Text(message.body),
  );
}