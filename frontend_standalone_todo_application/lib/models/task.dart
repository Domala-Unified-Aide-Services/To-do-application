class Task {
  int? id;
  String title;
  String description;
  String priority;
  bool completed;

  Task({
    this.id,
    required this.title,
    this.description = '',
    this.priority = 'medium',
    this.completed = false,
  });

  // Convert Task to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'completed': completed ? 1 : 0,
    };
  }

  // Create Task from Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'] ?? '',
      priority: map['priority'] ?? 'medium',
      completed: map['completed'] == 1,
    );
  }
}
