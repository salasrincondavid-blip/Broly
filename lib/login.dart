import 'package:broly_1_1/main.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login Page'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Flutter Demo Home Page')),
                );
              },
              child: const Text('ir a la página de inicio'),
            ),
          ],
        ),
      ),
    );
  }
}

class textfield extends StatelessWidget {
  const textfield({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Enter your username',
      ),
    );
  }
}