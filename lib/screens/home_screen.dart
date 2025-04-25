// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import '../widgets/task_card.dart';
import '../widgets/task_summary.dart';
import '../widgets/category_chip.dart';
import 'task_form_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Daftar Tugas', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Implementasi filter (opsional)
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: _taskService.getTasksStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt, size: 80, color: Colors.grey[300]),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada tugas',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tambahkan tugas baru dengan tombol + di bawah',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                List<Task> allTasks = snapshot.data!;
                List<Task> filteredTasks = _filterTasks(allTasks);
                
                // Tambahkan widget TaskSummary
                return Column(
                  children: [
                    TaskSummary(tasks: allTasks),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Icon(Icons.filter_list, color: Colors.grey[600], size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Filter: $_selectedCategory',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '${filteredTasks.length} tugas',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    if (filteredTasks.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.filter_alt_off, size: 60, color: Colors.grey[300]),
                              SizedBox(height: 16),
                              Text(
                                'Tidak ada tugas dalam kategori ini',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            Task task = filteredTasks[index];
                            return TaskCard(
                              task: task,
                              onTap: () => _navigateToTaskForm(context, task),
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
        onPressed: () => _navigateToTaskForm(context, null),
      ),
    );
  }

  // Nilai filter kategori
  String _selectedCategory = 'Semua';
  final List<String> _categories = ['Semua', 'Hari ini', 'Selesai', 'Belum selesai', 'Prioritas tinggi'];

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      color: Colors.blueAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat Datang',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Kelola Tugas Anda',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                border: InputBorder.none,
                hintText: 'Cari tugas...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(height: 15),
          
          // Category filters
          Container(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _categories.map((category) {
                return CategoryChip(
                  label: category,
                  isSelected: _selectedCategory == category,
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  color: _getCategoryColor(category),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
  
  // Helper untuk mendapatkan warna kategori
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Prioritas tinggi':
        return Colors.red[400]!;
      case 'Selesai':
        return Colors.green[400]!;
      case 'Hari ini':
        return Colors.orange[400]!;
      case 'Belum selesai':
        return Colors.purple[400]!;
      default:
        return Colors.blueAccent;
    }
  }
  
  // Fungsi untuk filter tugas berdasarkan kategori yang dipilih
  List<Task> _filterTasks(List<Task> tasks) {
    switch (_selectedCategory) {
      case 'Hari ini':
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        return tasks.where((task) {
          if (task.dueDate == null) return false;
          final taskDate = DateTime(
            task.dueDate!.year,
            task.dueDate!.month,
            task.dueDate!.day,
          );
          return taskDate.isAtSameMomentAs(today);
        }).toList();
        
      case 'Selesai':
        return tasks.where((task) => task.isCompleted).toList();
        
      case 'Belum selesai':
        return tasks.where((task) => !task.isCompleted).toList();
        
      case 'Prioritas tinggi':
        return tasks.where((task) => task.priority == 'tinggi').toList();
        
      default: // 'Semua'
        return tasks;
    }
  }

  Widget _buildTaskCard(Task task) {
    Color priorityColor;
    switch (task.priority) {
      case 'tinggi':
        priorityColor = Colors.red[400]!;
        break;
      case 'sedang':
        priorityColor = Colors.orange[300]!;
        break;
      case 'rendah':
        priorityColor = Colors.green[300]!;
        break;
      default:
        priorityColor = Colors.orange[300]!;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToTaskForm(context, task),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.priority.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        color: priorityColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                      color: task.isCompleted ? Colors.green : Colors.grey,
                    ),
                    onPressed: () {
                      _taskService.toggleTaskCompletion(task);
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                task.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  color: task.isCompleted ? Colors.grey : Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                task.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  if (task.dueDate != null)
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          _dateFormat.format(task.dueDate!),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _navigateToTaskForm(context, task),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                  SizedBox(width: 16),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteConfirmation(context, task),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Berpindah ke halaman formulir tugas
  void _navigateToTaskForm(BuildContext context, Task? task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: task),
      ),
    );
  }

  // Menampilkan dialog konfirmasi penghapusan
  void _showDeleteConfirmation(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin menghapus tugas ini?'),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _taskService.deleteTask(task.id!);
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tugas berhasil dihapus')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}