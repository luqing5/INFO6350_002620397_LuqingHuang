// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBF9WSjLK9yFtLk-taWpo0YXPRBGfztErM',
    appId: '1:380830626833:web:e694e4dd7697e8471dedb0',
    messagingSenderId: '380830626833',
    projectId: 'info6350-exercise6',
    authDomain: 'info6350-exercise6.firebaseapp.com',
    storageBucket: 'info6350-exercise6.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyByX3A9IU0Yth2CbGakQLkRiulAZHpJnfY',
    appId: '1:380830626833:android:865f450934f9ecee1dedb0',
    messagingSenderId: '380830626833',
    projectId: 'info6350-exercise6',
    storageBucket: 'info6350-exercise6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtS4l6QR60cmi7WJoAtZTd5NXuWohyY0w',
    appId: '1:380830626833:ios:f2efed531b5e74941dedb0',
    messagingSenderId: '380830626833',
    projectId: 'info6350-exercise6',
    storageBucket: 'info6350-exercise6.firebasestorage.app',
    iosClientId: '380830626833-7g3fs11ge46tg6ojn9bb52ul54lbn4pi.apps.googleusercontent.com',
    iosBundleId: 'com.example.exercise6',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDtS4l6QR60cmi7WJoAtZTd5NXuWohyY0w',
    appId: '1:380830626833:ios:f2efed531b5e74941dedb0',
    messagingSenderId: '380830626833',
    projectId: 'info6350-exercise6',
    storageBucket: 'info6350-exercise6.firebasestorage.app',
    iosClientId: '380830626833-7g3fs11ge46tg6ojn9bb52ul54lbn4pi.apps.googleusercontent.com',
    iosBundleId: 'com.example.exercise6',
  );
}
