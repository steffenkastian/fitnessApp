import 'dart:math';

class Uebungen {
  final Map<String, List<String>> uebungen = {
    "Bauch": [
      "Sit-Ups", "Crunches", "Russian Twist", "Beine heben und senken",
      "Tips to toes", "Bycicle Crunch", "Hollow hold"
    ],
    "ABeine": [
      "90-90", "Tief stehen, auf Zehenspitzen und runter", "Einbeinig über Linie springen",
      "Ausfallschritte", "Kniebeugen", "Seitliche Kniebeugen",
      "Tief stehen und kleine Schritte", "Gesprungene Kniebeugen", "Tiefstehen und zur Seite springen"
    ],
    "Ganzkorper": [
      "Stand in Liegestütz", "Plank", "Plank links/rechts", "Liegestütz",
      "Schulter Tipps", "Burpees", "Mountain climber", "UAS in Liegestütz"
    ],
    "Rucken": [
      "Superman", "I-, Y-, T", "Butterfly reverse", "Bridge, hoch / runter",
      "Vierfüßlerstand, Ellebogen - Knie zusammen"
    ],
  };

  final List<String> warmup = [
    "Jumping Jacks", "Seilspringen", "Ski fahren", "Laufen + Arme Kreisen", "Schrittposition in Schrittposition"
  ];

  List<String> kategorien = [];
  int exerciseIndex = 0;
  final Random _random = Random();

  Uebungen() {
    shuffle();
  }

  void shuffle() {
    kategorien = uebungen.keys.toList();
    for (var kategorie in kategorien) {
      uebungen[kategorie]!.shuffle(_random);
    }
    warmup.shuffle(_random);
  }

  String getNextExercise() {
    int i = exerciseIndex;
    int katCount = kategorien.length;
    String kategorie = kategorien[i % katCount];
    List<String> list = uebungen[kategorie]!;
    int indexInList = (i ~/ katCount) + 1;

    if (indexInList >= list.length) {
      indexInList = list.length - 1;
    }

    exerciseIndex++;
    return list[indexInList];
  }

  List<List<dynamic>> createWarmup(int numExercises, {int zeitBelastung = 60}) {
    return warmup.take(numExercises).map((uebung) => [uebung, zeitBelastung]).toList();
  }

  List<List<dynamic>> createCircle({
    required int numExercises,
    int zeitBelastung = 40,
    int zeitPause = 30,
    int zeitPauseUebung = 15,
    int circleRunden = 3,
  }) {
    List<List<dynamic>> circle = [];

    for (int i = 0; i < numExercises; i++) {
      circle.add([getNextExercise(), zeitBelastung]);
      if (zeitPauseUebung > 0) {
        circle.add(["Pause", zeitPauseUebung]);
      }
    }

    List<List<dynamic>> circleGesamt = [];
    for (int i = 0; i < circleRunden; i++) {
      circleGesamt.addAll(circle);
      if (i != circleRunden - 1) {
        circleGesamt.add(["Pause", zeitPause]);
      }
    }

    return circleGesamt;
  }

  List<List<dynamic>> createHurricane({
    required int numBlocks,
    int zeitBelastung = 40,
    int zeitPause = 30,
  }) {
    List<List<dynamic>> training = [];

    for (int i = 0; i < numBlocks; i++) {
      List<List<dynamic>> block = [];
      for (int j = 0; j < 3; j++) {
        block.add([getNextExercise(), zeitBelastung]);
      }

      for (int j = 0; j < 3; j++) {
        training.addAll(block);
      }

      if (i != numBlocks - 1) {
        training.add(["Pause", zeitPause]);
      }
    }

    return training;
  }

  List<List<dynamic>> createClassicFitnessTraining({
    required int numExercises,
    int zeitBelastung = 60,
    int zeitPause = 30,
  }) {
    List<List<dynamic>> training = [];

    for (int i = 0; i < numExercises; i++) {
      String uebung = getNextExercise();
      for (int j = 0; j < 3; j++) {
        training.add([uebung, zeitBelastung]);
        if (j != 2 && i != numExercises - 1) {
          training.add(["Pause", zeitPause]);
        }
      }
    }

    return training;
  }
}
