import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  RemoteMessage notification;

  NotificationPage({super.key, required this.notification});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: Column(
        children: [
          ListTile(
              // title: Text(widget.notification.notification!.body!),
              // subtitle: Text(widget.notification.body!),
              ),
        ],
      ),
    );
  }
}
