// lib/widgets/task_summary.dart
import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskSummary extends StatelessWidget {
  final List<Task> tasks;

  TaskSummary({required this.tasks});

  @override
  Widget build(BuildContext context) {
    int total = tasks.length;
    int completed = tasks.where((task) => task.isCompleted).length;
    int pending = total - completed;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat(
            title: 'Total',
            value: total.toString(),
            color: Colors.blue,
            icon: Icons.assignment,
          ),
          _buildDivider(),
          _buildStat(
            title: 'Selesai',
            value: completed.toString(),
            color: Colors.green,
            icon: Icons.check_circle,
          ),
          _buildDivider(),
          _buildStat(
            title: 'Belum Selesai',
            value: pending.toString(),
            color: Colors.orange,
            icon: Icons.pending_actions,
          ),
        ],
      ),
    );
  }

  Widget _buildStat({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[300],
    );
  }
}