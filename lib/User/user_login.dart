import 'package:flutter/material.dart';
import 'package:lockappsystem/User/user_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> loginUser() async {
    final userId = userIdController.text.trim();
    final password = passwordController.text.trim();

    if (userId.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both User ID and Password")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!docSnapshot.exists) {
        showError("User ID not found");
        setState(() => isLoading = false);
        return;
      }

      final data = docSnapshot.data();

      if (data == null || !data.containsKey('password')) {
        showError("User data is incomplete");
        setState(() => isLoading = false);
        return;
      }

      final hashedInput = password.toString();

      final storedHashed = data['password'];

      if (hashedInput == storedHashed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => UserHomePage(userId: userId),
          ),
        );
      } else {
        showError("Invalid password");
      }
    } catch (e) {
      showError("Login failed: ${e.toString()}");
    }

    setState(() => isLoading = false);
  }

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: userIdController,
              decoration: InputDecoration(labelText: 'User ID'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      await loginUser();
                    },
                    child: Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}
