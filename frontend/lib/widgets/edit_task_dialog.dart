import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class EditTaskDialog extends StatefulWidget {
  final Task task;

  EditTaskDialog({required this.task});

  @override
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  // <--- NEW STATE VARIABLE --->
  late String _selectedPriority;

  final List<String> _priorityOptions = ['high', 'medium', 'low'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description ?? '');
    // <--- INITIALIZE WITH CURRENT PRIORITY --->
    _selectedPriority = widget.task.priority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Title Input
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // 2. Priority Dropdown <--- NEW UI ELEMENT --->
            DropdownButtonFormField<String>(
              value: _selectedPriority,
              decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.priority_high),
              ),
              items: _priorityOptions.map((String priority) {
                return DropdownMenuItem<String>(
                  value: priority,
                  child:
                      Text(priority[0].toUpperCase() + priority.substring(1)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPriority = newValue!;
                });
              },
              validator: (value) =>
                  value == null ? 'Please select a priority' : null,
            ),

            SizedBox(height: 16),

            // 3. Description Input
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                // Check if any value actually changed before calling API
                final newTitle = _titleController.text.trim();
                final newDescription =
                    _descriptionController.text.trim().isNotEmpty
                        ? _descriptionController.text.trim()
                        : null;

                // Call updateTask with the new priority
                await Provider.of<TaskProvider>(context, listen: false)
                    .updateTask(
                  widget.task.id,
                  newTitle,
                  _selectedPriority, // <--- NEW ARGUMENT: Pass selected priority
                  newDescription,
                );

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Task updated successfully!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update task: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          icon: Icon(Icons.save),
          label: Text('Save'),
        ),
      ],
    );
  }
}
