import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/habit_provider.dart';
import 'add_edit_habit_screen.dart';
import 'progress_screen.dart';
import '../widgets/habit_item.dart';
import '../models/habit.dart';
import '../screens/register_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AuthProvider _auth;
  late HabitProvider _habitProv;
  String _userId = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<AuthProvider>(context);
    _habitProv = Provider.of<HabitProvider>(context, listen: false);
    final user = _auth.currentUser;
    if (user != null) {
      _userId = user.id;
      _habitProv.habitsFor(_userId); // trigger load
    }
  }

  @override
  Widget build(BuildContext context) {
    final habits = Provider.of<HabitProvider>(context).habitsFor(_userId);
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () => Navigator.pushNamed(context, ProgressScreen.routeName),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: habits.isEmpty
          ? Center(child: Text('Belum ada habit. Tambah dengan tombol +'))
          : ListView.builder(
              itemCount: habits.length,
              itemBuilder: (ctx, i) {
                final h = habits[i];
                final todayKey = '${DateTime.now().year.toString().padLeft(4,'0')}-${DateTime.now().month.toString().padLeft(2,'0')}-${DateTime.now().day.toString().padLeft(2,'0')}';
                final isDone = h.checks[todayKey] == true;
                return HabitItem(
                  habit: h,
                  isDoneToday: isDone,
                  onToggle: () => Provider.of<HabitProvider>(context, listen:false).toggleCheck(_userId, h.id, DateTime.now()),
                  onEdit: () => Navigator.pushNamed(context, AddEditHabitScreen.routeName, arguments: {'mode':'edit', 'habit': h, 'userId': _userId}),
                  onDelete: () => _confirmDelete(h.id),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AddEditHabitScreen.routeName, arguments: {'mode':'add', 'userId': _userId}),
        child: Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Hapus habit?'),
        content: Text('Yakin ingin menghapus habit ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Provider.of<HabitProvider>(context, listen:false).deleteHabit(_userId, id);
              Navigator.pop(context);
            },
            child: Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
