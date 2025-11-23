import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class AddEditHabitScreen extends StatefulWidget {
  static const routeName = '/add-edit-habit';
  @override
  _AddEditHabitScreenState createState() => _AddEditHabitScreenState();
}

class _AddEditHabitScreenState extends State<AddEditHabitScreen> {
  final _nameCtl = TextEditingController();
  bool _isEdit = false;
  Habit? _habit;
  String? _userId;

  @override
  void dispose() {
    _nameCtl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _isEdit = args['mode'] == 'edit';
      _habit = args['habit'];
      _userId = args['userId'];
      if (_isEdit && _habit != null) {
        _nameCtl.text = _habit!.name;
      }
      if (!_isEdit && _userId == null) {
        _userId = args['userId'];
      }
    }
  }

  Future<void> _save() async {
    final name = _nameCtl.text.trim();
    if (name.isEmpty) return;
    final prov = Provider.of<HabitProvider>(context, listen:false);
    if (_isEdit && _habit != null) {
      _habit!.name = name;
      await prov.updateHabit(_userId!, _habit!);
    } else {
      final id = Uuid().v4();
      final newHabit = Habit(id: id, name: name);
      await prov.addHabit(_userId!, newHabit);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Habit' : 'Tambah Habit')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: _nameCtl, decoration: InputDecoration(labelText: 'Nama Habit')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: Text('Simpan'), style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(48))),
          ],
        ),
      ),
    );
  }
}
