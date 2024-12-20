import 'package:chat_application_1/user_list/controller/user_list_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:chat_application_1/chat/view/chat_screen.dart';
import 'package:chat_application_1/auth/controller/login_controller.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<UserListController>().initState(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final watchAuth = Provider.of<AuthController>(context, listen: true);
    final watch = Provider.of<UserListController>(context);
    final read = Provider.of<UserListController>(context);

    final currentUserId = watchAuth.user?.uid ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: watch.fetchUsers(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () => _showUserDetailsDialog(context, user),
                      child: CircleAvatar(
                        child: const Icon(Icons.person),
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    title: Text(
                      user['name'] ?? 'Unknown',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'Email: ${user['email'] ?? 'Not Available'}\n'
                      'Phone: ${user['phone'] ?? 'Not Available'}\n'
                      'Age: ${user['age'] ?? 'Not Available'}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    isThreeLine: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            currentUserId: currentUserId,
                            otherUserId: user['id'],
                            otherUserName: user['name'],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showUserDetailsDialog(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(user['name'] ?? 'User Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Email: ${user['email'] ?? 'Not Available'}'),
              Text('Phone: ${user['phone'] ?? 'Not Available'}'),
              Text('Age: ${user['age'] ?? 'Not Available'}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
