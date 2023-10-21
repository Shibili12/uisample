import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uisample/main.dart';

class Firebasenotification {
  final _firebasemessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _firebasemessaging.requestPermission();
    final fCMtoken = await _firebasemessaging.getToken();
    print("token:$fCMtoken");
    initPushnotification();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState
        ?.pushNamed('/notification_screen', arguments: message);
  }

  Future<void> initPushnotification() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
