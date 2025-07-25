import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

Future<String> logout() async {
  await FirebaseAuth.instance.signOut();
  return "🚪 Ausgeloggt.";
}


class _AuthPageState extends State<AuthPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? statusMessage;

  Future<void> register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      setState(() {
        statusMessage = "✅ Registrierung erfolgreich!";
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        statusMessage = "❌ Fehler: ${e.message}";
      });
    }
  }

  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      setState(() {
        statusMessage = "✅ Login erfolgreich!";
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        statusMessage = "❌ Fehler: ${e.message}";
      });
    }
  }

  Future<void> logout2() async {
    await FirebaseAuth.instance.signOut();
    final message = await logout();
    setState(() {
      statusMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Login/Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (user != null) Text('Angemeldet als: ${user.uid}'),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-Mail'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Passwort'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: register, child: const Text('Registrieren')),
            ElevatedButton(onPressed: login, child: const Text('Login')),
            ElevatedButton(onPressed: logout2, child: const Text('Logout')),
            if (statusMessage != null) ...[
              const SizedBox(height: 16),
              Text(statusMessage!, style: const TextStyle(fontSize: 16)),
            ],
          ],
        ),
      ),
    );
  }
}
