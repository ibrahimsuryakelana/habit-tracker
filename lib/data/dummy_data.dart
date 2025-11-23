import '../models/habit.dart';

List<Habit> getInitialHabits() {
  return [
    Habit(id: 'h1', name: 'Bangun pagi'),
    Habit(id: 'h2', name: 'Olahraga 30 menit'),
    Habit(id: 'h3', name: 'Baca buku 20 menit'),
  ];
}
