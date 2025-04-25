// lib/services/task_service.dart
import 'package:firebase_database/firebase_database.dart';
import '../models/task_model.dart';

class TaskService {
  final DatabaseReference _tasksRef = FirebaseDatabase.instance.ref().child('tasks');

  // Mendapatkan referensi stream untuk mendengarkan perubahan data
  Stream<List<Task>> getTasksStream() {
    return _tasksRef.onValue.map((event) {
      final Map<dynamic, dynamic>? data = event.snapshot.value as Map?;
      if (data == null) return [];
      
      List<Task> tasks = [];
      data.forEach((key, value) {
        tasks.add(Task.fromMap(value, key));
      });
      
      // Urutkan tugas berdasarkan status penyelesaian dan prioritas
      tasks.sort((a, b) {
        // Prioritaskan tugas yang belum selesai
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        
        // Urutkan berdasarkan prioritas
        Map<String, int> priorityMap = {'rendah': 0, 'sedang': 1, 'tinggi': 2};
        int aPriority = priorityMap[a.priority] ?? 1;
        int bPriority = priorityMap[b.priority] ?? 1;
        
        if (aPriority != bPriority) {
          return bPriority - aPriority; // Prioritas tinggi lebih dulu
        }
        
        // Jika prioritas sama, urutkan berdasarkan tanggal jatuh tempo
        if (a.dueDate != null && b.dueDate != null) {
          return a.dueDate!.compareTo(b.dueDate!);
        } else if (a.dueDate != null) {
          return -1;
        } else if (b.dueDate != null) {
          return 1;
        }
        
        return 0;
      });
      
      return tasks;
    });
  }

  // Menambahkan tugas baru
  Future<void> addTask(Task task) async {
    try {
      await _tasksRef.push().set(task.toMap());
    } catch (e) {
      print("Error menambahkan tugas: $e");
      throw e;
    }
  }

  // Memperbarui tugas yang sudah ada
  Future<void> updateTask(Task task) async {
    if (task.id == null) return;
    try {
      await _tasksRef.child(task.id!).update(task.toMap());
    } catch (e) {
      print("Error memperbarui tugas: $e");
      throw e;
    }
  }

  // Menghapus tugas
  Future<void> deleteTask(String taskId) async {
    try {
      await _tasksRef.child(taskId).remove();
    } catch (e) {
      print("Error menghapus tugas: $e");
      throw e;
    }
  }

  // Mengubah status penyelesaian tugas
  Future<void> toggleTaskCompletion(Task task) async {
    if (task.id == null) return;
    task.isCompleted = !task.isCompleted;
    await updateTask(task);
  }
}