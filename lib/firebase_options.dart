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
    apiKey: 'AIzaSyDhbgKQ2ZnZUGpQ6lzaKLFRCt0_HT-zglI',
    appId: '1:618669779574:web:3584aa64b962bbaabd4d57',
    messagingSenderId: '618669779574',
    projectId: 'nexttrip-de3eb',
    authDomain: 'nexttrip-de3eb.firebaseapp.com',
    storageBucket: 'nexttrip-de3eb.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCaficVwcl7L0Dve6qXe1wjmz7ETjCR508',
    appId: '1:618669779574:android:98d6d5616819ac4bbd4d57',
    messagingSenderId: '618669779574',
    projectId: 'nexttrip-de3eb',
    storageBucket: 'nexttrip-de3eb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA9H2_MQyG5fuOpM_3z7YDnn56auVJncpg',
    appId: '1:618669779574:ios:cbd5a8e13126d376bd4d57',
    messagingSenderId: '618669779574',
    projectId: 'nexttrip-de3eb',
    storageBucket: 'nexttrip-de3eb.firebasestorage.app',
    androidClientId:
        '618669779574-kkh7qjst3sa65chut69jk1pmd3j1ovr2.apps.googleusercontent.com',
    iosClientId:
        '618669779574-fuvl8pe91kucr2h95qu97aismcv6moj3.apps.googleusercontent.com',
    iosBundleId: 'com.example.nextTrip',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA9H2_MQyG5fuOpM_3z7YDnn56auVJncpg',
    appId: '1:618669779574:ios:cbd5a8e13126d376bd4d57',
    messagingSenderId: '618669779574',
    projectId: 'nexttrip-de3eb',
    storageBucket: 'nexttrip-de3eb.firebasestorage.app',
    androidClientId:
        '618669779574-kkh7qjst3sa65chut69jk1pmd3j1ovr2.apps.googleusercontent.com',
    iosClientId:
        '618669779574-fuvl8pe91kucr2h95qu97aismcv6moj3.apps.googleusercontent.com',
    iosBundleId: 'com.example.nextTrip',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDhbgKQ2ZnZUGpQ6lzaKLFRCt0_HT-zglI',
    appId: '1:618669779574:web:c3b93beca77d35a0bd4d57',
    messagingSenderId: '618669779574',
    projectId: 'nexttrip-de3eb',
    authDomain: 'nexttrip-de3eb.firebaseapp.com',
    storageBucket: 'nexttrip-de3eb.firebasestorage.app',
  );
}
