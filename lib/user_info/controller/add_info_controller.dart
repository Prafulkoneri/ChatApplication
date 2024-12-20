
import 'package:chat_application_1/auth/controller/login_controller.dart';
import 'package:chat_application_1/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// class AddinfoController extends ChangeNotifier {
//    FirebaseFirestore _firestore = FirebaseFirestore.instance;
//    TextEditingController emailController = TextEditingController();
//    TextEditingController passwordController = TextEditingController();
//     TextEditingController nameController = TextEditingController();

//    TextEditingController ageController = TextEditingController();

//    TextEditingController phoneController = TextEditingController();
//   User? _user;
//   String? errorMessage;

//   User? get user => _user;

//   Future<void> initState( context) async {}


//   Future<void> saveUserDetails(context, String name, int age, String phone) async {
//     try {
//       if (_user != null) {
//         await _firestore.collection('users').doc(_user!.uid).set({
//           'id': _user!.uid,
//           'name': name,
//           'age': age,
//           'phone': phone,
//           'email': _user!.email,
//         });
//         Utils.showPrimarySnackbar(context, "User details saved successfully!", type: SnackType.success);
//         notifyListeners();
//       } else {
//         Utils.showPrimarySnackbar(context, "User not logged in.", type: SnackType.error);
//       }
//     } catch (e) {
//       Utils.showPrimarySnackbar(context, "Failed to save user details: $e", type: SnackType.error);
//       notifyListeners();
//     }
//   }

// }
class AddinfoController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Future<void> saveUserDetails(
      BuildContext context, String name, int age, String phone) async {
    try {
      final authController = context.read<AuthController>();
      final user = authController.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'name': name,
          'age': age,
          'phone': phone,
          'email': user.email,
        });
        Utils.showPrimarySnackbar(
          context,
          "User details saved successfully!",
          type: SnackType.success,
        );
        notifyListeners();
      } else {
        Utils.showPrimarySnackbar(
          context,
          "User not logged in.",
          type: SnackType.error,
        );
      }
    } catch (e) {
      Utils.showPrimarySnackbar(
        context,
        "Failed to save user details: $e",
        type: SnackType.error,
      );
      notifyListeners();
    }
  }
}
