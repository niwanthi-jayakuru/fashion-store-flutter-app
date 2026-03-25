import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                "Welcome Back 👋",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final user = await authService.login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );

                    if (user != null) {
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Login Failed ❌")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const Text("Login"),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text("Don't have an account? Register"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
