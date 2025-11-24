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
    final weekly = hp.weeklyProgress(userId); // 7 days: oldest → newest

    return Scaffold(
      appBar: AppBar(
        title: Text('Progres'),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 164, 174, 231),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ------------------------------
            //   CARD – TODAY PROGRESS
            // ------------------------------
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.indigoAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Progres Hari ini",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Big %
                  Center(
                    child: Text(
                      '$percent%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 46,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: hp.todayCompletionPercent(userId),
                      minHeight: 14,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // ------------------------------
            //   WEEKLY CHART TITLE
            // ------------------------------
            Text(
              'Grafik 7 Hari Terakhir',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            SizedBox(height: 18),

            // ------------------------------
            //   BAR CHART
            // ------------------------------
            SizedBox(
              height: 240,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (i) {
                  final value = weekly[i];
                  final height = (value * 180) + 10;
                  final day = _weekdayLabel(i);

                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${(value * 100).round()}%',
                          style: TextStyle(fontSize: 12, color: Colors.indigo),
                        ),
                        SizedBox(height: 4),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                          height: height,
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(day, style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                }),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _weekdayLabel(int idx) {
    final now = DateTime.now();
    final target = now.subtract(Duration(days: 6 - idx));
    final names = ['Min','Sen','Sel','Rab','Kam','Jum','Sab'];
    return names[target.weekday % 7];
  }
}
