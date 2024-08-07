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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCnMaSLOL-pC39WALaZCNxosyw3L1tKOx0',
    appId: '1:150496980543:android:242290751e11cbac8fd28a',
    messagingSenderId: '150496980543',
    projectId: 'grubb-ba0e4',
    databaseURL: 'https://grubb-ba0e4.firebaseio.com',
    storageBucket: 'grubb-ba0e4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCszTozRWu-St62eVbqpEhiX3iHMe1Ie_A',
    appId: '1:150496980543:ios:9ca77c870358408a8fd28a',
    messagingSenderId: '150496980543',
    projectId: 'grubb-ba0e4',
    databaseURL: 'https://grubb-ba0e4.firebaseio.com',
    storageBucket: 'grubb-ba0e4.appspot.com',
    androidClientId: '150496980543-0f7t3j0kq86l8mdae36pobql6637n2b8.apps.googleusercontent.com',
    iosBundleId: 'com.dl.locate',
  );
}
