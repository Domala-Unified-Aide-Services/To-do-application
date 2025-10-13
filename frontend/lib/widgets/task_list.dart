import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'edit_task_dialog.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  TaskList({required this.tasks});

  // Helper function to map priority string to a color
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Helper function to show the delete confirmation dialog
  Future<bool?> _showDeleteConfirmation(BuildContext context, Task task) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];

        // Determine text decoration based on completion
        final textDecoration =
            task.completed ? TextDecoration.lineThrough : null;
        final textColor = task.completed ? Colors.grey : null;

        return Dismissible(
          key: Key(task.id.toString()),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) => _showDeleteConfirmation(context, task),
          onDismissed: (direction) {
            Provider.of<TaskProvider>(context, listen: false)
                .deleteTask(task.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Task deleted')),
            );
          },
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Row(
                children: [
                  // --- PRIORITY CHIP ---
                  Chip(
                    label: Text(
                      task.priority.toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: _getPriorityColor(task.priority),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                  ),
                  SizedBox(width: 8),
                  // --- TASK TITLE ---
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        decoration: textDecoration,
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              subtitle: task.description != null && task.description!.isNotEmpty
                  ? Text(
                      task.description!,
                      style: TextStyle(
                        decoration: textDecoration,
                        color: textColor,
                      ),
                    )
                  : null,

              leading: Checkbox(
                value: task.completed,
                onChanged: (value) {
                  Provider.of<TaskProvider>(context, listen: false)
                      .toggleTask(task.id);
                },
              ),

              // --- FIX HERE: Add mainAxisSize.min to the Row ---
              trailing: Row(
                mainAxisSize: MainAxisSize.min, // THIS IS THE KEY FIX
                children: [
                  // EDIT BUTTON
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditTaskDialog(task: task),
                      );
                    },
                  ),
                  // --- RE-ADDED DELETE BUTTON ---
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirmed =
                          await _showDeleteConfirmation(context, task);

                      if (confirmed == true) {
                        Provider.of<TaskProvider>(context, listen: false)
                            .deleteTask(task.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Task deleted')),
                        );
                      }
                    },
                  ),
                ],
              ),
              onTap: () {
                // Allows tapping anywhere on the card to edit
                showDialog(
                  context: context,
                  builder: (context) => EditTaskDialog(task: task),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
