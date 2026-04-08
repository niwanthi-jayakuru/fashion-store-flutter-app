import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
          'DefaultFirebaseOptions are not supported for this platform. sadasd',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAvWV0Hty_hSLb0lql11aEA5LhpWp_a0I0',
    appId: '1:1009004769830:web:515c823ae7e1618f45ace7',
    messagingSenderId: '1009004769830',
    projectId: 'fashion-store-15952',
    authDomain: 'fashion-store-15952.firebaseapp.com',
    storageBucket: 'fashion-store-15952.firebasestorage.app',
    measurementId: 'G-X4TR01LNSB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBFVqwlqCdfv1PvpRXMsWiTjRQfJI12Oo8',
    appId: '1:1009004769830:android:3018a9e06bd2109a45ace7',
    messagingSenderId: '1009004769830',
    projectId: 'fashion-store-15952',
    storageBucket: 'fashion-store-15952.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA6-L7fxKlIZqcR3W7QflMywdhntokYFoo',
    appId: '1:1009004769830:ios:7970cfcb3ad9ad6045ace7',
    messagingSenderId: '1009004769830',
    projectId: 'fashion-store-15952',
    storageBucket: 'fashion-store-15952.firebasestorage.app',
    iosBundleId: 'com.example.fashionStore',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA6-L7fxKlIZqcR3W7QflMywdhntokYFoo',
    appId: '1:1009004769830:ios:7970cfcb3ad9ad6045ace7',
    messagingSenderId: '1009004769830',
    projectId: 'fashion-store-15952',
    storageBucket: 'fashion-store-15952.firebasestorage.app',
    iosBundleId: 'com.example.fashionStore',
  );

}
