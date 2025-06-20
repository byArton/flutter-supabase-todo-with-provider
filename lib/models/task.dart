import 'package:flutter/foundation.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final String priority;
  final ValueNotifier<bool> isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.priority,
    required bool isCompleted,
  }) : isCompleted = ValueNotifier(isCompleted);

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'].toString(),
      title: map['title'] ?? '',
      description: map['description'],
      dueDate: map['due_date'] != null ? DateTime.parse(map['due_date']) : null,
      priority: map['priority'] ?? 'medium',
      isCompleted: map['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'due_date': dueDate?.toIso8601String(),
    'priority': priority,
    'is_completed': isCompleted.value,
  };
}
