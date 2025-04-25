// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    } else {
      throw UnsupportedError(
        'DefaultFirebaseOptions tidak tersedia untuk platform ini.',
      );
    }
  }

  // Nilai-nilai dari google-services.json Anda
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCnJGDPba4VsuZNUB_Ryw4dktZz47oWx2g',
    appId: '1:454182025535:android:87ff8ac72d06859acbfb8a',
    messagingSenderId: '454182025535',
    projectId: 'projectfirebase-70666',
    storageBucket: 'projectfirebase-70666.firebasestorage.app',
    databaseURL: 'https://projectfirebase-70666-default-rtdb.asia-southeast1.firebasedatabase.app/',
  );
}