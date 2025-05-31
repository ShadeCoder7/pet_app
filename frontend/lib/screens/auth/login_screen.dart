import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controllers for retrieving input values
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Hope&Paws - Login Screen')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 32),
                // Email input
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),
                // Password input
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 24),
                // Login button
                ElevatedButton(
                  onPressed: () {
                    // For now, just navigate to the main menu (replace with your auth logic later)
                    Navigator.pushNamed(context, '/main');
                  },
                  child: Text('Login'),
                ),
                SizedBox(height: 12),
                // Go back to onboarding
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/onboarding');
                  },
                  child: Text('Back to Onboarding'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
