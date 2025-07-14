import 'dart:async';
import 'package:flutter/material.dart';

class WorkoutPage extends StatefulWidget {
  final List<List<dynamic>> workout;

  const WorkoutPage({super.key, required this.workout});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late int _currentIndex;
  late int _countdown;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _countdown = widget.workout[_currentIndex][1];
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else {
          if (_currentIndex < widget.workout.length - 1) {
            _currentIndex++;
            _countdown = widget.workout[_currentIndex][1];
          } else {
            _timer?.cancel();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentExercise = widget.workout[_currentIndex][0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout läuft'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Aktuelle Übung:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              currentExercise,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Text(
              'Verbleibende Zeit: $_countdown s',
              style: const TextStyle(fontSize: 28, color: Colors.red),
            ),
            if (_currentIndex+1<widget.workout.length) ...[
              if (widget.workout[_currentIndex+1][0]=="Pause") ...[
                Text('\n Nächste Übung: ${widget.workout[_currentIndex+2][0]}',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
              ]
              else
                Text('\n Nächste Übung: ${widget.workout[_currentIndex+1][0]}',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
            ],
          ],
        ),
      ),
    );
  }
}
