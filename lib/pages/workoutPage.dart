import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

final player = AudioPlayer();

void playSound(String fileName) {
  player.play(AssetSource('sounds/$fileName'));
}

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
          if (_countdown<4)  playSound('mixkit-censorship-beep-1082.wav');
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Aktuelle Übung:',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '$currentExercise',
                            style: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '$_countdown s',
                            style: const TextStyle(fontSize: 100),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32),
                        if (_currentIndex + 1 < widget.workout.length)
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Nächste Übung: ${_getNextExerciseName()}',
                              style: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  String _getNextExerciseName() {
    if (_currentIndex + 2 < widget.workout.length &&
        widget.workout[_currentIndex + 1][0] == "Pause") {
      return widget.workout[_currentIndex + 2][0];
    }
    return widget.workout[_currentIndex + 1][0];
  }
}