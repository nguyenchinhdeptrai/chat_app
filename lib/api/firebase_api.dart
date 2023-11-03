import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroudMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotification() async {
    // quyenf người dùng
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    _firebaseMessaging.subscribeToTopic('chat');

    FirebaseMessaging.onBackgroundMessage(handleBackgroudMessage);
  }
}
