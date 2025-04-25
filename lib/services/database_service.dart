// lib/services/database_service.dart
import 'package:firebase_database/firebase_database.dart';
import '../models/item_model.dart';

class DatabaseService {
  final databaseURL = 'https://projectfirebase-70666-default-rtdb.asia-southeast1.firebasedatabase.app/';
  late final DatabaseReference _itemsRef;
  
  DatabaseService() {
    final db = FirebaseDatabase.instance;
    db.databaseURL = databaseURL;
    _itemsRef = db.ref().child('items');
  }

  // Mendapatkan referensi stream untuk mendengarkan perubahan data
  Stream<List<Item>> getItemsStream() {
    return _itemsRef.onValue.map((event) {
      final Map<dynamic, dynamic>? data = event.snapshot.value as Map?;
      if (data == null) return [];
      
      List<Item> items = [];
      data.forEach((key, value) {
        items.add(Item.fromMap(value, key));
      });
      return items;
    });
  }

  // Menambahkan item baru dengan error handling yang lebih baik
  Future<void> addItem(Item item) async {
    try {
      print("Mencoba menambahkan item ke database: ${item.title}");
      await _itemsRef.push().set(item.toMap());
      print("Item berhasil ditambahkan ke database");
    } catch (e) {
      print("Error menambahkan item: $e");
      throw e;
    }
  }

  // Memperbarui item yang sudah ada
  Future<void> updateItem(Item item) async {
    if (item.id == null) return;
    await _itemsRef.child(item.id!).update(item.toMap());
  }

  // Menghapus item
  Future<void> deleteItem(String itemId) async {
    await _itemsRef.child(itemId).remove();
  }

  // Mendapatkan item berdasarkan ID
  Future<Item?> getItemById(String itemId) async {
    DatabaseEvent event = await _itemsRef.child(itemId).once();
    if (event.snapshot.value != null) {
      return Item.fromMap(
        event.snapshot.value as Map<dynamic, dynamic>, 
        itemId
      );
    }
    return null;
  }
}