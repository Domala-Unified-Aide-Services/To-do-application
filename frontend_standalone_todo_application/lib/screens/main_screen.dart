import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/edit_task_dialog.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // Load tasks when the screen starts
    Provider.of<TaskProvider>(context, listen: false).loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              provider.loadTasks(); // ✅ fixed: using curly braces
            },
          ),
        ],
      ),
      body: provider.tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks found',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: provider.tasks.length,
              itemBuilder: (context, index) {
                final task = provider.tasks[index];
                return ListTile(
                  leading: Checkbox(
                    value: task.completed,
                    onChanged: (value) async {
                      final success = await provider.toggleTask(task.id!);
                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Could not update task. Please try again.'),
                          ),
                        );
                      }
                    },
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: task.completed ? Colors.grey : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    'Priority: ${task.priority}\n${task.description ?? ""}',
                    style: TextStyle(
                      decoration: task.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: task.completed ? Colors.grey : Colors.black87,
                    ),
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => EditTaskDialog(task: task),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => provider.deleteTask(task.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AddTaskDialog(),
          );
        },
      ),
    );
  }
}
