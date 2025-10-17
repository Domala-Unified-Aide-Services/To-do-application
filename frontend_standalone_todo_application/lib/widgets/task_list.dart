import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'edit_task_dialog.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  const TaskList({required this.tasks, super.key});

  @override
  Widget build(BuildContext context) {
    // Changed: Remove listen: false so UI rebuilds on changes
    final taskProvider = Provider.of<TaskProvider>(context);

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: ListTile(
            leading: Checkbox(
              value: task.completed,
              onChanged: (value) async {
                await taskProvider.toggleTask(task.id!);
              },
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                decoration: task.completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: task.completed ? Colors.grey : Colors.black,
              ),
            ),
            subtitle: Text(
              'Priority: ${task.priority[0].toUpperCase()}${task.priority.substring(1)}\n${task.description}',
              style: TextStyle(
                color: task.completed ? Colors.grey : Colors.black87,
                decoration: task.completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => EditTaskDialog(task: task),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    taskProvider.deleteTask(task.id!);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
