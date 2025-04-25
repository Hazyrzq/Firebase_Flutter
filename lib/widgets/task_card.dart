// lib/widgets/task_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Function onTap;
  final TaskService taskService = TaskService();
  final DateFormat dateFormat = DateFormat('dd MMM yyyy');

  TaskCard({
    required this.task,
    required this.onTap,
  });

  Color _getPriorityColor() {
    switch (task.priority) {
      case 'tinggi':
        return Colors.red[400]!;
      case 'sedang':
        return Colors.orange[300]!;
      case 'rendah':
        return Colors.green[300]!;
      default:
        return Colors.orange[300]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => onTap(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPriorityColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.priority.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getPriorityColor(),
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
                      taskService.toggleTaskCompletion(task);
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
              if (task.dueDate != null) ...[
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      dateFormat.format(task.dueDate!),
                      style: TextStyle(
                        fontSize: 12,
                        color: _isOverdue(task.dueDate!) ? Colors.red : Colors.grey[600],
                      ),
                    ),
                    if (_isOverdue(task.dueDate!) && !task.isCompleted)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'TERLAMBAT',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool _isOverdue(DateTime dueDate) {
    final now = DateTime.now();
    return dueDate.isBefore(DateTime(now.year, now.month, now.day));
  }
}