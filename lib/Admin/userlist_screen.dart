import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lockappsystem/Admin/admin_Screen.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final TextEditingController passwordController = TextEditingController();
  Future<void> toggleLockStatus(String deviceId, bool lock) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(deviceId)
        .update({'isLocked': lock});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Devices')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AdminPage()));
              },
              child: const Row(
                children: [
                  Icon(Icons.add),
                  Text("Add users"),
                ],
              )),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No users found.'));
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final deviceId = doc.id;
                    final data = doc.data() as Map<String, dynamic>;
                    final isLocked = data['isLocked'] ?? false;

                    return ListTile(
                      title: Text('Device ID: $deviceId'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(isLocked ? 'Locked' : 'Unlocked'),
                          Switch(
                            value: isLocked,
                            onChanged: (value) {
                              toggleLockStatus(deviceId, value);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
