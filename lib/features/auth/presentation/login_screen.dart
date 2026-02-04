import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: ElevatedButton(
          child: const Text("Sign in with Google",style: TextStyle(color: Colors.black),),
          onPressed: () => AuthService().signInWithGoogle(),
        ),
      ),
    );
  }
}
