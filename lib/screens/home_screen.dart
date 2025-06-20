import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/my_checkbox.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> addOrUpdateTaskDialog(
    BuildContext context, {
    Task? original,
  }) async {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    final titleCtrl = TextEditingController(text: original?.title ?? '');
    final descCtrl = TextEditingController(text: original?.description ?? '');
    DateTime? due = original?.dueDate;
    String priority = original?.priority ?? 'medium';

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StatefulBuilder(
            builder: (context, setStateDialog) => SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    original == null ? '新規タスク' : 'タスクを編集',
                    style: GoogleFonts.notoSansJp(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleCtrl,
                    decoration: InputDecoration(
                      labelText: 'タイトル',
                      labelStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descCtrl,
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: '詳細（任意）',
                      labelStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: Colors.blueGrey,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: due ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setStateDialog(() => due = picked);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 9,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  due != null
                                      ? DateFormat('yyyy/MM/dd').format(due!)
                                      : '期限なし',
                                  style: GoogleFonts.notoSansJp(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                                if (due != null)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () =>
                                        setStateDialog(() => due = null),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.flag_rounded,
                        color: Colors.orange,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      DropdownButton<String>(
                        value: priority,
                        style: GoogleFonts.notoSansJp(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        underline: Container(
                          height: 1,
                          color: Colors.blue[100],
                        ),
                        items: const [
                          DropdownMenuItem(value: 'high', child: Text('高')),
                          DropdownMenuItem(value: 'medium', child: Text('中')),
                          DropdownMenuItem(value: 'low', child: Text('低')),
                        ],
                        onChanged: (v) =>
                            setStateDialog(() => priority = v ?? 'medium'),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            side: const BorderSide(color: Color(0xFFEEEEEE)),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          child: const Text('キャンセル'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            textStyle: GoogleFonts.notoSansJp(
                              fontWeight: FontWeight.w700,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () async {
                            if (titleCtrl.text.isEmpty) {
                              Fluttertoast.showToast(msg: 'タイトルを入力してください');
                              return;
                            }
                            final task = Task(
                              id: original?.id ?? '',
                              title: titleCtrl.text,
                              description: descCtrl.text,
                              dueDate: due,
                              priority: priority,
                              isCompleted: original?.isCompleted.value ?? false,
                            );
                            await provider.addOrUpdateTask(
                              task,
                              isUpdate: original != null,
                            );
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                              msg: original == null ? '追加成功' : '編集成功',
                            );
                          },
                          child: Text(original == null ? '作成' : '更新'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Color _priorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.redAccent;
      case 'low':
        return Colors.grey;
      default:
        return Colors.blueAccent;
    }
  }

  static String _priorityJp(String priority) {
    switch (priority) {
      case 'high':
        return '高';
      case 'low':
        return '低';
      default:
        return '中';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'タスク管理',
              style: GoogleFonts.notoSansJp(
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.tasks.isEmpty
              ? const Center(
                  child: Text(
                    'タスクはありません',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                )
              : ListView.builder(
                  itemCount: provider.tasks.length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, i) {
                    final t = provider.tasks[i];
                    return Card(
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.2,
                          children: [
                            SlidableAction(
                              onPressed: (_) async {
                                await provider.deleteTask(t.id);
                                Fluttertoast.showToast(msg: '削除しました');
                              },
                              icon: Icons.delete_outline,
                              label: '削除',
                              backgroundColor: Colors.red.withOpacity(0.08),
                              foregroundColor: Colors.red,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: MyCheckBox(
                            valueNotifier: t.isCompleted,
                            onChanged: (checked) async {
                              await provider.toggleCompleted(t, checked);
                            },
                          ),
                          title: ValueListenableBuilder<bool>(
                            valueListenable: t.isCompleted,
                            builder: (context, checked, _) => Text(
                              t.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.notoSansJp(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                decoration: checked
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: checked
                                    ? Colors.black38
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          subtitle: (t.dueDate != null || t.priority.isNotEmpty)
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Row(
                                    children: [
                                      if (t.dueDate != null)
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_today,
                                              size: 13,
                                              color: Colors.blueGrey,
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              DateFormat(
                                                'yyyy/MM/dd',
                                              ).format(t.dueDate!),
                                              style: GoogleFonts.notoSansJp(
                                                fontSize: 13,
                                                color: Colors.blueGrey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (t.dueDate != null &&
                                          t.priority.isNotEmpty)
                                        const SizedBox(width: 10),
                                      if (t.priority.isNotEmpty)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _priorityColor(t.priority),
                                            borderRadius: BorderRadius.circular(
                                              7,
                                            ),
                                          ),
                                          child: Text(
                                            _priorityJp(t.priority),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                              : null,
                          trailing: IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 22),
                            onPressed: () =>
                                addOrUpdateTaskDialog(context, original: t),
                            splashRadius: 24,
                          ),
                        ),
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0.8,
            onPressed: () => addOrUpdateTaskDialog(context),
            shape: const CircleBorder(),
            child: const Icon(Icons.add, size: 32),
          ),
        );
      },
    );
  }
}
