import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // dopasowane tło
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Tu można dodać nawigację do logowania
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                // Tu można dodać nawigację do rejestracji
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
