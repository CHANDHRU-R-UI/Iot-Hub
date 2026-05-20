import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC-mpCxjfZVMrwcWhT80QwHAFjDxE6FizU',
    appId: '1:375971558683:web:1085d756d5bf27b1910fbe',
    messagingSenderId: '375971558683',
    projectId: 'iot-hub-07',
    authDomain: 'iot-hub-07.firebaseapp.com',
    storageBucket: 'iot-hub-07.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC-mpCxjfZVMrwcWhT80QwHAFjDxE6FizU',
    appId: '1:375971558683:android:1085d756d5bf27b1910fbe',
    messagingSenderId: '375971558683',
    projectId: 'iot-hub-07',
    storageBucket: 'iot-hub-07.firebasestorage.app',
  );
}
