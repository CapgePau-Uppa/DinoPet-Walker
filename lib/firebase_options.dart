import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForWebDevelopment123456789',
    appId: '1:123456789:web:abcdef1234567890',
    messagingSenderId: '123456789',
    projectId: 'dinopetwalker',
    authDomain: 'dinopetwalker.firebaseapp.com',
    storageBucket: 'dinopetwalker.appspot.com',
  );
}
