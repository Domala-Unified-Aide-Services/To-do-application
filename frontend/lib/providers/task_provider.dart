import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final ApiService _apiService = ApiService();

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    _tasks = await _apiService.fetchTasks();
    notifyListeners();
  }

  // UPDATED: Added 'priority' as a required argument
  Future<void> addTask(String title, String priority,
      [String? description]) async {
    // 1. Create a temporary Task object for sending data
    final taskData = Task(
      id: 0, // A placeholder ID
      title: title,
      description: description,
      completed: false,
      priority: priority, // <--- NEW: Pass the selected priority
    );

    // 2. Await the API call, which returns the fully realized task with the real database ID.
    // NOTE: This relies on the fix we discussed in api_service.dart (returning Task).
    final Task newTaskWithId = await _apiService.addTask(taskData);

    // 3. Add the task with the REAL ID to the local list.
    _tasks.insert(0, newTaskWithId);
    notifyListeners();
  }

  Future<void> toggleTask(int id) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      final task = _tasks[taskIndex];
      await _apiService.updateTask(id, !task.completed);

      _tasks[taskIndex] = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        completed: !task.completed,
        priority: task.priority, // <--- NEW: Preserve existing priority
      );

      notifyListeners();
    }
  }

  // UPDATED: Added 'priority' to updateTask method
  Future<void> updateTask(int id, String title, String priority,
      [String? description]) async {
    // We need to update the API call to send the priority
    await _apiService.updateTaskContent(id, title, priority,
        description); // <-- Needs new parameter in api_service

    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      // Update the task object in the local list
      _tasks[taskIndex] = Task(
        id: id,
        title: title,
        description: description,
        completed: _tasks[taskIndex].completed,
        priority: priority, // <--- NEW: Update the local priority
      );
      notifyListeners();
    }
  }

  Future<void> deleteTask(int id) async {
    await _apiService.deleteTask(id);
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}
