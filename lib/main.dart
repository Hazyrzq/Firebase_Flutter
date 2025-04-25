import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Check jika ada aplikasi yang sudah berjalan
    if (Firebase.apps.isNotEmpty) {
      await Firebase.app('[DEFAULT]').delete();
    }
    
    // Inisialisasi dengan opsi yang benar
    await Firebase.initializeApp(
      name: '[DEFAULT]',
      options: FirebaseOptions(
        apiKey: 'AIzaSyCnJGDPba4VsuZNUB_Ryw4dktZz47oWx2g',
        appId: '1:454182025535:android:87ff8ac72d06859acbfb8a',
        messagingSenderId: '454182025535',
        projectId: 'projectfirebase-70666',
        storageBucket: 'projectfirebase-70666.firebasestorage.app',
        databaseURL: 'https://projectfirebase-70666-default-rtdb.asia-southeast1.firebasedatabase.app',
      ),
    );
    
    print("Firebase berhasil diinisialisasi");
    
    // Inisialisasi database
    final FirebaseDatabase database = FirebaseDatabase.instance;
    // Contoh pengaturan persistence jika diperlukan
    try {
      // Hapus await karena fungsi ini return void
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000); // 10MB
    } catch (e) {
      print("Error saat mengatur persistence: $e");
    }
    
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Tugas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.blueAccent,
        ),
      ),
      home: HomeScreen(),
    );
  }
}