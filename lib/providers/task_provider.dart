import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await supabase.from('tasks').select().order('due_date');
      _tasks = (res as List).map((e) => Task.fromMap(e)).toList();
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addOrUpdateTask(Task task, {bool isUpdate = false}) async {
    final map = task.toMap()..remove('id');
    try {
      if (!isUpdate) {
        await supabase.from('tasks').insert(map);
      } else {
        await supabase.from('tasks').update(map).eq('id', task.id);
      }
      await fetchTasks();
    } catch (_) {}
  }

  Future<void> deleteTask(String id) async {
    try {
      await supabase.from('tasks').delete().eq('id', id);
      await fetchTasks();
    } catch (_) {}
  }

  Future<void> toggleCompleted(Task task, bool checked) async {
    try {
      // 楽観的UI
      await supabase
          .from('tasks')
          .update({'is_completed': checked})
          .eq('id', task.id);
      // fetchTasks()を呼ばず部分的UI
    } catch (_) {
      task.isCompleted.value = !checked;
    }
  }
}
