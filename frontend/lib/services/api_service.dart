import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/task.dart';

class ApiService {
  // Define the base path
  static const String _apiPath = '/flutter_1/backend/api/';

  // Replace this IP with your PC's local IPv4 address from ipconfig
  static const String _localNetworkIP = '49.37.158.68';

  static final String baseUrl = _getBaseUrl();

  static String _getBaseUrl() {
    if (kIsWeb) {
      // For web (if running Flutter Web from Chrome)
      return 'http://localhost$_apiPath';
    } else {
      // For mobile (connected to same Wi-Fi)
      return 'http://$_localNetworkIP$_apiPath';
    }
  }

  Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse('${baseUrl}get_tasks.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['tasks'] as List)
          .map((json) => Task.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<Task> addTask(Task task) async {
    final response = await http.post(
      Uri.parse('${baseUrl}add_task.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      if (data['success'] == true && data.containsKey('task')) {
        return Task.fromJson(data['task']);
      } else {
        throw Exception('API response missing "task" data.');
      }
    } else {
      String errorMessage = 'Failed to add task';
      try {
        final errorData = json.decode(response.body);
        errorMessage = errorData['error'] ?? errorMessage;
      } catch (_) {}
      throw Exception(errorMessage);
    }
  }

  Future<void> updateTask(int id, bool completed) async {
    final response = await http.get(
      Uri.parse(
          '${baseUrl}update_task.php?id=$id&completed=${completed ? 1 : 0}'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  Future<void> updateTaskContent(
      int id, String title, String priority, String? description) async {
    final response = await http.post(
      Uri.parse('${baseUrl}update_task_content.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': id,
        'title': title,
        'description': description,
        'priority': priority,
      }),
    );

    if (response.statusCode != 200) {
      String errorMessage = 'Failed to update task content';
      try {
        final errorData = json.decode(response.body);
        errorMessage = errorData['error'] ?? errorMessage;
      } catch (_) {}
      throw Exception(errorMessage);
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.get(
      Uri.parse('${baseUrl}delete_task.php?id=$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}  