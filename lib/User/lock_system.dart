import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LockDevicePage extends StatelessWidget {
  static const platform = MethodChannel('device_lock');

  Future<void> lockDevice() async {
    try {
      requestAdminPermission();
      await platform.invokeMethod('lockDevice');
    } on PlatformException catch (e) {
      SnackBar(content: Text("Failed to lock device: '${e.message}'."));
    }
  }

  Future<void> requestAdminPermission() async {
    try {
      await platform.invokeMethod('requestAdmin');
    } on PlatformException catch (e) {
      SnackBar(content: Text("Failed to request permission: '${e.message}'."));
    }
  }

  Future<void> disbaleCemara() async {
    try {
      requestAdminPermission();
      await platform.invokeMethod('disableCamera');
    } on PlatformException catch (e) {
      SnackBar(content: Text("Failed to Disable Camera: '${e.message}'."));
    }
  }

  Future<void> startKiosMode() async {
    try {
      requestAdminPermission();
      await platform.invokeMethod('startKioskMode');
    } on PlatformException catch (e) {
      SnackBar(content: Text("Failed to start KiosK mode: '${e.message}'."));
    }
  }

  Future<void> stopKiosMode() async {
    try {
      requestAdminPermission();
      await platform.invokeMethod('stopKioskMode');
    } on PlatformException catch (e) {
      SnackBar(content: Text("Failed to stop KiosK mode: '${e.message}'."));
    }
  }

  Future<void> blockUninstall() async {
    try {
      requestAdminPermission();
      await platform.invokeMethod('blockUninstall');
    } on PlatformException catch (e) {
      SnackBar(content: Text("Failed to block install: '${e.message}'."));
    }
  }

  Future<void> unblockUninstall() async {
    try {
      requestAdminPermission();
      await platform.invokeMethod('unblockUninstall');
    } on PlatformException catch (e) {
      SnackBar(content: Text("Failed to unblock install: '${e.message}'."));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lock Device')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: lockDevice,
              child: const Text('Lock Now'),
            ),
            ElevatedButton(
              onPressed: disbaleCemara,
              child: const Text('Disbale Cemara'),
            ),
            ElevatedButton(
              onPressed: startKiosMode,
              child: const Text('KiosK Mode'),
            ),
            ElevatedButton(
              onPressed: stopKiosMode,
              child: const Text('Stop KiosK Mode'),
            ),
            ElevatedButton(
              onPressed: blockUninstall,
              child: const Text('Block Uninstall'),
            ),
            ElevatedButton(
              onPressed: unblockUninstall,
              child: const Text('unBlock Uninstall'),
            ),
            // const QRScreen()
          ],
        ),
      ),
    );
  }
}
