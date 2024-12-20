// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:chat_application_1/auth/controller/login_controller.dart';

// class UserProfileController extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Map<String, dynamic>? _userData;
//   String? _error;
//   bool _isLoading = false;

//   Map<String, dynamic>? get userData => _userData;
//   String? get error => _error;
//   bool get isLoading => _isLoading;

//   Future<void> fetchUserDetails(AuthController authController) async {
//     final user = authController.user;

//     if (user == null) {
//       _error = "User not logged in.";
//       notifyListeners();
//       return;
//     }

//     try {
//       _isLoading = true;
//       _error = null;
//       notifyListeners();

//       DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();

//       _userData = doc.data() as Map<String, dynamic>?;
//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       _error = "Failed to fetch user data: $e";
//       notifyListeners();
//     }
//   }
//     void initState(
//     context,
    
//   ) async {
//     notifyListeners();
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_application_1/auth/controller/login_controller.dart';

class UserProfileController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? _userData;
  String? _error;
  bool _isLoading = false;

  // Getters
  Map<String, dynamic>? get userData => _userData;
  String? get error => _error;
  bool get isLoading => _isLoading;

  // Fetch user details from Firestore
  Future<void> fetchUserDetails(AuthController authController) async {
    final user = authController.user;

    if (user == null) {
      _error = "User not logged in.";
      _isLoading = false;
      _userData = null;
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Fetch user details from Firestore
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        _userData = doc.data() as Map<String, dynamic>?;
      } else {
        _userData = null;
        _error = "No user data found for the user ID: ${user.uid}";
      }
    } catch (e) {
      _error = "Failed to fetch user data: $e";
      _userData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
