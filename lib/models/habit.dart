import 'dart:convert';

class Habit {
  String id;
  String name;
  DateTime createdAt;
  // checks: key = yyyy-MM-dd, value = true/false
  Map<String, bool> checks;

  Habit({
    required this.id,
    required this.name,
    DateTime? createdAt,
    Map<String, bool>? checks,
  })  : this.createdAt = createdAt ?? DateTime.now(),
        this.checks = checks ?? {};

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'checks': checks,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> m) {
    final checksMap = <String, bool>{};
    if (m['checks'] != null) {
      Map<String, dynamic> rawChecks = Map<String, dynamic>.from(m['checks']);
      rawChecks.forEach((k, v) {
        checksMap[k] = v == true;
      });
    }
    return Habit(
      id: m['id'],
      name: m['name'],
      createdAt: DateTime.parse(m['createdAt']),
      checks: checksMap,
    );
  }

  String toJson() => json.encode(toMap());

  factory Habit.fromJson(String source) => Habit.fromMap(json.decode(source));
}
