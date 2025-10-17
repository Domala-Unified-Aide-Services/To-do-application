import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class TaskProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  // Load all tasks
  Future<void> loadTasks() async {
    _tasks = await _apiService.getTasks();
    notifyListeners();
  }

  // Add task
  Future<void> addTask(Task task) async {
    await _apiService.addTask(task);
    await loadTasks();
  }

  // Update task
  Future<void> updateTask(Task task) async {
    await _apiService.updateTask(task);
    await loadTasks();
  }

  // Delete task
  Future<void> deleteTask(int id) async {
    await _apiService.deleteTask(id);
    await loadTasks();
  }

  // ✅ Toggle completed task — returns bool to indicate success/failure
  Future<bool> toggleTask(int id) async {
    try {
      final index = _tasks.indexWhere((task) => task.id == id);
      if (index == -1) return false;

      // Update local state first for instant UI feedback
      _tasks[index] = Task(
        id: _tasks[index].id,
        title: _tasks[index].title,
        description: _tasks[index].description,
        priority: _tasks[index].priority,
        completed: !_tasks[index].completed,
      );
      notifyListeners();

      // Try updating the database
      await _apiService.updateTask(_tasks[index]);
      return true; // ✅ Success
    } catch (e) {
      print('Error toggling task: $e');
      return false; // ❌ Failure
    }
  }
}
