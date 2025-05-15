import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController imeIController = TextEditingController();

  createUser(context) async {
    final password = passwordController.text;
    final hashedPassword = password.toString();

    final docRef =
        FirebaseFirestore.instance.collection('users').doc(imeIController.text);
    await docRef.set({
      "password": hashedPassword,
      "isLocked": false,
      "createdAt": DateTime.now().toIso8601String(),
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: imeIController,
              decoration: InputDecoration(labelText: 'User ID'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Set Password'),
            ),
            ElevatedButton(
              onPressed: () async {
                await createUser(context);
              },
              child: Text('Register Device'),
            ),
          ],
        ),
      ),
    );
  }
}
