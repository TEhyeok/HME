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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyA5VrhSpFse61QqrXtcZTWDt221RqPXaO8',
    appId: '1:67098031251:web:531f274c3d18e670d44966',
    messagingSenderId: '67098031251',
    projectId: 'hme-project-d03a1',
    authDomain: 'hme-project-d03a1.firebaseapp.com',
    storageBucket: 'hme-project-d03a1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyASyWa-au58qkt_9TLggVnwhn_tL8T32VA',
    appId: '1:67098031251:ios:4277cb18195a33e1d44966',
    messagingSenderId: '67098031251',
    projectId: 'hme-project-d03a1',
    storageBucket: 'hme-project-d03a1.appspot.com',
    iosBundleId: 'com.example.finalProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyASyWa-au58qkt_9TLggVnwhn_tL8T32VA',
    appId: '1:67098031251:ios:4277cb18195a33e1d44966',
    messagingSenderId: '67098031251',
    projectId: 'hme-project-d03a1',
    storageBucket: 'hme-project-d03a1.appspot.com',
    iosBundleId: 'com.example.finalProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA5VrhSpFse61QqrXtcZTWDt221RqPXaO8',
    appId: '1:67098031251:web:728a2613ec8b6eafd44966',
    messagingSenderId: '67098031251',
    projectId: 'hme-project-d03a1',
    authDomain: 'hme-project-d03a1.firebaseapp.com',
    storageBucket: 'hme-project-d03a1.appspot.com',
  );

}