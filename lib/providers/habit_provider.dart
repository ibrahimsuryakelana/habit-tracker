import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';
import '../data/dummy_data.dart';

class HabitProvider with ChangeNotifier {
  Map<String, List<Habit>> _userHabits = {};
  static const String _habitsKeyPrefix = 'habits_'; // + userId

  HabitProvider() {
    // nothing here, load per user on demand
  }

  List<Habit> habitsFor(String userId) {
    if (!_userHabits.containsKey(userId)) {
      _loadHabits(userId);
      return [];
    }
    return _userHabits[userId]!;
  }

  Future<void> _loadHabits(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_habitsKeyPrefix$userId');
    if (raw != null) {
      final list = json.decode(raw) as List<dynamic>;
      _userHabits[userId] = list.map((e) => Habit.fromMap(Map<String, dynamic>.from(e))).toList();
    } else {
      // seed initial dummy habits once
      _userHabits[userId] = getInitialHabits();
      await _saveHabits(userId);
    }
    notifyListeners();
  }

  Future<void> _saveHabits(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = _userHabits[userId]!.map((h) => h.toMap()).toList();
    await prefs.setString('$_habitsKeyPrefix$userId', json.encode(list));
  }

  Future<void> addHabit(String userId, Habit habit) async {
    if (!_userHabits.containsKey(userId)) _userHabits[userId] = [];
    _userHabits[userId]!.add(habit);
    await _saveHabits(userId);
    notifyListeners();
  }

  Future<void> updateHabit(String userId, Habit habit) async {
    final idx = _userHabits[userId]!.indexWhere((h) => h.id == habit.id);
    if (idx >= 0) {
      _userHabits[userId]![idx] = habit;
      await _saveHabits(userId);
      notifyListeners();
    }
  }

  Future<void> deleteHabit(String userId, String habitId) async {
    _userHabits[userId]!.removeWhere((h) => h.id == habitId);
    await _saveHabits(userId);
    notifyListeners();
  }

  // Toggle today's check
  Future<void> toggleCheck(String userId, String habitId, DateTime date) async {
    final dayKey = _formatDate(date);
    final habit = _userHabits[userId]!.firstWhere((h) => h.id == habitId);
    final current = habit.checks[dayKey] ?? false;
    habit.checks[dayKey] = !current;
    await _saveHabits(userId);
    notifyListeners();
  }

  String _formatDate(DateTime d) {
    return '${d.year.toString().padLeft(4,'0')}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
  }

  // Calculate today's completion percent
  double todayCompletionPercent(String userId) {
    final list = _userHabits[userId] ?? [];
    if (list.isEmpty) return 0.0;
    final dayKey = _formatDate(DateTime.now());
    final completed = list.where((h) => h.checks[dayKey] == true).length;
    return completed / list.length;
  }

  // Weekly progress: returns list of percent for last 7 days (oldest first)
  List<double> weeklyProgress(String userId) {
    final list = _userHabits[userId] ?? [];
    final res = <double>[];
    for (int i = 6; i >= 0; i--) {
      final d = DateTime.now().subtract(Duration(days: i));
      final key = _formatDate(d);
      if (list.isEmpty) {
        res.add(0.0);
      } else {
        final done = list.where((h) => h.checks[key] == true).length;
        res.add(done / list.length);
      }
    }
    return res;
  }
}
