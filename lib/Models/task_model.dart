// lib/models/task_model.dart
class Task {
  String? id;
  String title;
  String description;
  bool isCompleted;
  DateTime? dueDate;
  String priority; // 'rendah', 'sedang', 'tinggi'

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.dueDate,
    this.priority = 'sedang',
  });

  // Konversi dari Firebase snapshot ke objek Task
  factory Task.fromMap(Map<dynamic, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      priority: map['priority'] ?? 'sedang',
    );
  }

  // Konversi dari objek Task ke Map untuk Firebase
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority,
    };
  }
}