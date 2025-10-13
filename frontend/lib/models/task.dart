class Task {
  final int id;
  final String title;
  final String? description;
  final bool completed;
  final String priority; // <--- NEW FIELD

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.completed,
    required this.priority, // <--- REQUIRED IN CONSTRUCTOR
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: int.parse(json['id'].toString()),
      title: json['title'].toString(),
      description: json['description']?.toString(),
      completed: json['completed'].toString() == '1',
      // <--- NEW: Read priority from JSON. Default to 'medium' if missing
      // (important for compatibility with existing tasks before the DB change).
      priority: json['priority']?.toString() ?? 'medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed ? 1 : 0,
      'priority':
          priority, // <--- NEW: Include priority in the JSON to be sent to the API
    };
  }
}
