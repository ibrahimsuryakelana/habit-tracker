import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitItem extends StatelessWidget {
  final Habit habit;
  final bool isDoneToday;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HabitItem({
    Key? key,
    required this.habit,
    required this.isDoneToday,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical:6, horizontal:10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: IconButton(
          icon: isDoneToday ? Icon(Icons.check_circle, color: Colors.green) : Icon(Icons.check_circle_outline),
          onPressed: onToggle,
        ),
        title: Text(habit.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        subtitle: Text('Dibuat: ${habit.createdAt.toLocal().toString().split(' ').first}'),
        trailing: PopupMenuButton<int>(
          onSelected: (v) {
            if (v == 1) onEdit();
            if (v == 2) onDelete();
          },
          itemBuilder: (_) => [
            PopupMenuItem(child: Text('Edit'), value: 1),
            PopupMenuItem(child: Text('Delete'), value: 2),
          ],
        ),
      ),
    );
  }
}
