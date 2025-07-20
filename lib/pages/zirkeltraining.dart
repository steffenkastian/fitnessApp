import 'package:flutter/material.dart';
import 'package:my_fitness_app/models/uebungen.dart';
import 'package:my_fitness_app/pages/workoutPage.dart';

class ZirkelTraining extends StatefulWidget {
  const ZirkelTraining({super.key});

  @override
  State<ZirkelTraining> createState() => _ZirkelTrainingState();
}

class _ZirkelTrainingState extends State<ZirkelTraining> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _warmupController = TextEditingController(text: "5");
  final TextEditingController _numExercisesController = TextEditingController(text: "16");
  final TextEditingController _belastungController = TextEditingController(text: "60");
  final TextEditingController _pauseController = TextEditingController(text: "0");
  final TextEditingController _rundenController = TextEditingController(text: "3");

  List<List<Object>> workout = [];

  void _generateWorkout() {
    final int zeitWarmup = int.tryParse(_warmupController.text) ?? 0;
    final int numExercises = int.tryParse(_numExercisesController.text) ?? 0;
    final int zeitBelastung = int.tryParse(_belastungController.text) ?? 0;
    final int zeitPause = int.tryParse(_pauseController.text) ?? 0;
    final int runden = int.tryParse(_rundenController.text) ?? 0;

    final Uebungen trainingGenerator = Uebungen();

    final warmup = trainingGenerator.createWarmup(zeitWarmup).map((e) => e.cast<Object>()).toList();
    final hauptteil = trainingGenerator.createCircle(
      numExercises: numExercises,
      zeitBelastung: zeitBelastung,
      zeitPauseUebung: zeitPause,
      circleRunden: runden,
    ).map((e) => e.cast<Object>()).toList();

    setState(() {
      workout = [...warmup, ...hauptteil];
    });
  }

  void _startWorkout() {
    if (workout.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPage(workout: workout),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zirkel Training'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _warmupController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Übungen Warmup'),
              ),
              TextFormField(
                controller: _numExercisesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Anzahl Übungen'),
              ),
              TextFormField(
                controller: _belastungController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Belastungszeit (s)'),
              ),
              TextFormField(
                controller: _pauseController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Pause nach Übung (s)'),
              ),
              TextFormField(
                controller: _rundenController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Anzahl Runden'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _generateWorkout,
                child: const Text('Workout erstellen'),
              ),
              if (workout.isNotEmpty) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _startWorkout,
                  child: const Text('Workout starten'),
                ),
                const Text("Dein Workout:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...workout.map((entry) => Text('• ${entry[0]} – ${entry[1]} s')),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
