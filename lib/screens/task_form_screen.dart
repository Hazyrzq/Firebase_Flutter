// lib/screens/task_form_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TaskService _taskService = TaskService();
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isCompleted = false;
  DateTime? _dueDate;
  String _priority = 'sedang';

  List<String> priorities = ['rendah', 'sedang', 'tinggi'];

  @override
  void initState() {
    super.initState();
    
    // Jika task tidak null, berarti kita sedang mengedit task
    if (widget.task != null) {
      _titleController = TextEditingController(text: widget.task!.title);
      _descriptionController = TextEditingController(text: widget.task!.description);
      _isCompleted = widget.task!.isCompleted;
      _dueDate = widget.task!.dueDate;
      _priority = widget.task!.priority;
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final String title = _titleController.text;
      final String description = _descriptionController.text;

      try {
        if (widget.task == null) {
          // Menambahkan task baru
          Task newTask = Task(
            title: title,
            description: description,
            isCompleted: _isCompleted,
            dueDate: _dueDate,
            priority: _priority,
          );
          await _taskService.addTask(newTask);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tugas berhasil ditambahkan')),
          );
        } else {
          // Memperbarui task yang ada
          Task updatedTask = Task(
            id: widget.task!.id,
            title: title,
            description: description,
            isCompleted: _isCompleted,
            dueDate: _dueDate,
            priority: _priority,
          );
          await _taskService.updateTask(updatedTask);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tugas berhasil diperbarui')),
          );
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blueAccent,
            colorScheme: ColorScheme.light(primary: Colors.blueAccent),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.task == null ? 'Tambah Tugas' : 'Edit Tugas'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul tugas
                Text(
                  'Judul',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan judul tugas',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 24),
                
                // Deskripsi tugas
                Text(
                  'Deskripsi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan deskripsi tugas',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 24),
                
                // Tanggal jatuh tempo
                Text(
                  'Tanggal Jatuh Tempo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.grey[600]),
                        SizedBox(width: 12),
                        Text(
                          _dueDate == null
                              ? 'Pilih tanggal'
                              : _dateFormat.format(_dueDate!),
                          style: TextStyle(
                            color: _dueDate == null ? Colors.grey[500] : Colors.black87,
                          ),
                        ),
                        Spacer(),
                        if (_dueDate != null)
                          IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey[600]),
                            onPressed: () {
                              setState(() {
                                _dueDate = null;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Prioritas
                Text(
                  'Prioritas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _priority,
                      isExpanded: true,
                      items: priorities.map((String priority) {
                        return DropdownMenuItem<String>(
                          value: priority,
                          child: Text(
                            priority.toUpperCase(),
                            style: TextStyle(
                              color: priority == 'tinggi'
                                  ? Colors.red[700]
                                  : priority == 'sedang'
                                      ? Colors.orange[700]
                                      : Colors.green[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _priority = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Status penyelesaian
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CheckboxListTile(
                    title: Text(
                      'Selesai',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    value: _isCompleted,
                    activeColor: Colors.blueAccent,
                    onChanged: (bool? value) {
                      if (value != null) {
                        setState(() {
                          _isCompleted = value;
                        });
                      }
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                
                SizedBox(height: 32),
                
                // Tombol simpan
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveTask,
                    child: Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}