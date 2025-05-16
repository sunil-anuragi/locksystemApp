import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserHomePage extends StatefulWidget {
  final String userId;
  const UserHomePage({required this.userId});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  static const platform = MethodChannel('device_lock');
  bool isLocked = false;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data()?['isLocked'] == true) {
        setState(() {
          isLocked = true;
        });
        startKiosMode();
      } else {
        setState(() {
          isLocked = false;
        });
        stopKiosMode();
      }
    });
  }

  Future<void> startKiosMode() async {
    try {
      await requestAdminPermission();
      await platform.invokeMethod('startKioskMode');
    } on PlatformException catch (e) {
      SnackBar(content: Text("Failed to start KiosK mode: '${e.message}'."));
    }
  }

  Future<void> stopKiosMode() async {
    try {
      await requestAdminPermission();
      await platform.invokeMethod('stopKioskMode');
    } on PlatformException catch (e) {
      SnackBar(content: Text("Failed to stop KiosK mode: '${e.message}'."));
    }
  }

  Future<void> requestAdminPermission() async {
    try {
      await platform.invokeMethod('requestAdmin');
    } on PlatformException catch (e) {
      SnackBar(content: Text("Failed to request permission: '${e.message}'."));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Mode')),
      body: Center(
          child: Text(isLocked
              ? "Device is locked by Admin"
              : "Device is unlocked by Admin")),
    );
  }
}
