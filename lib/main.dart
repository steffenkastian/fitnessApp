import 'package:flutter/material.dart';
import 'dart:async';

import 'package:my_fitness_app/models/uebungen.dart';
import 'package:my_fitness_app/pages/zirkeltraining.dart';
import 'auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // wird bei Firebase-Setup generiert

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // <- das ist wichtig!
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steffens Fitness',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 51, 105, 56)),
      ),
      home: const MyHomePage(title: 'Steffens Fitness App'),
//      home: const AuthPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _countdown = 0;
  
  Uebungen trainingGenerator = Uebungen();

  final int _currentIndex = 0;
  List<List<dynamic>> workout = [];



  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (user != null) ... [
              Text('Angemeldet als: ${user.email}'),
              ElevatedButton(onPressed: () {logout; setState(() { });}, child: const Text("Logout")),
            ] else ... [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthPage()),
                  );
                },
                child: const Text('Login'),
              ),
            ],
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ZirkelTraining()),
                );
              },
              child: const Text('Zirkel Training'),
            ),
            if (_countdown > 0) ... [
              Text('Aktuelle Übung: ${workout[_currentIndex][0]}',style: const TextStyle(fontSize: 48, color: Color.fromARGB(255, 51, 2, 212)),),
              Text('$_countdown s',style: const TextStyle(fontSize: 80, color: Color.fromARGB(255, 51, 2, 212),),),
              if (_currentIndex+1 < workout.length) ...[
                if (workout[_currentIndex+1][0]== "Pause") ...[
                  Text('Nächste Übung: ${workout[_currentIndex+2][0]}',style: const TextStyle(fontSize: 48, color: Color.fromARGB(255, 51, 2, 212)),),     
                ]           
                else
                  Text('Nächste Übung: ${workout[_currentIndex+1][0]}',style: const TextStyle(fontSize: 48, color: Color.fromARGB(255, 51, 2, 212)),),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
