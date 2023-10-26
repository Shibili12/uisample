import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  List<RemoteMessage> notifications;

  NotificationPage({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Notification"),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop(notifications.length);
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        body: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: ((context, index) {
              final ntf = notifications[index];
              return ListTile(
                title: Text(ntf.notification?.title ?? ""),
                subtitle: Text(ntf.notification?.body ?? ""),
              );
            })));
  }
}
