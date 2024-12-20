import 'package:chat_application_1/auth/view/login_view.dart';
import 'package:chat_application_1/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:chat_application_1/auth/controller/login_controller.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final authController = context.read<AuthController>();
      context.read<UserProfileController>().fetchUserDetails(authController);
    });
  }

  // Logout method
  void _logout(BuildContext context) {
    final authController = context.read<AuthController>();
    authController.logout(); 

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final watch = context.watch<UserProfileController>();

    if (watch.isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text("User Profile")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (watch.error != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text("User Profile")),
        body: Center(child: Text(watch.error!)),
      );
    }

    final data = watch.userData;

    if (data == null || data.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("User Profile")),
        body: Center(child: Text('No user data found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Email: ${data['email'] ?? 'Not Available'}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Name: ${data['name'] ?? 'Not Available'}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Age: ${data['age'] ?? 'Not Available'}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Phone: ${data['phone'] ?? 'Not Available'}",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

