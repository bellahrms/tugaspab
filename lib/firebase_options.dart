import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    } else {
      throw UnsupportedError('Platform ini tidak didukung.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCipGWW73gxHwdmKfUEV_m9nolS99JrviY',
    appId: '1:914442182222:web:94dd8189d2dd65ad3a2d1f',
    messagingSenderId: '914442182222',
    projectId: 'wisata-sejarah-web',
    storageBucket: 'wisata-sejarah-web.firebasestorage.app',
    measurementId: 'G-3CQ0E8TNKK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCipGWW73gxHwdmKfUEV_m9nolS99JrviY',
    appId: '1:914442182222:android:94dd8189d2dd65ad3a2d1f', 
    messagingSenderId: '914442182222',
    projectId: 'wisata-sejarah-web',
    storageBucket: 'wisata-sejarah-web.firebasestorage.app',
  );
}