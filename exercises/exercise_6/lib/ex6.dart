import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permissions (optional for Android, required for iOS)
    messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    messaging.getToken().then((String? token) {
      assert(token != null);
      print("FCM Token: $token");
    });

    // Listen to messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message: ${message.notification?.title}');
    });

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('FCM Example')),
        body: Center(child: Text('Push Notifications Test')),
      ),
    );
  }
}
