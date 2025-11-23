import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/habit_provider.dart';

class ProgressScreen extends StatelessWidget {
  static const routeName = '/progress';
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final hp = Provider.of<HabitProvider>(context);
    final userId = auth.currentUser?.id ?? '';
    final percent = (hp.todayCompletionPercent(userId) * 100).round();
    final weekly = hp.weeklyProgress(userId); // last 7 days oldest->newest

    return Scaffold(
      appBar: AppBar(title: Text('Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Progress Hari Ini', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 12),
            Text('$percent%', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            LinearProgressIndicator(value: hp.todayCompletionPercent(userId), minHeight: 16),
            SizedBox(height: 24),
            Text('Grafik 7 Hari Terakhir', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 12),
            // Simple bar chart using containers
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: weekly.map((v) {
                  final heightPct = v; // 0..1
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${(v*100).round()}%', style: TextStyle(fontSize:12)),
                          SizedBox(height:6),
                          Container(
                            height: 200 * heightPct + 6,
                            decoration: BoxDecoration(
                              color: Colors.indigo,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          SizedBox(height:6),
                          Text(_weekdayLabel(weekly.indexOf(v)), style: TextStyle(fontSize:12))
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  String _weekdayLabel(int idx) {
    // idx 0..6 -> map to day short labels (older->newer)
    final now = DateTime.now();
    final target = now.subtract(Duration(days: 6 - idx));
    final names = ['Min','Sen','Sel','Rab','Kam','Jum','Sab'];
    return names[target.weekday % 7];
  }
}
