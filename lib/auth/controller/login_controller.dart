import 'package:chat_application_1/user_info/controller/add_info_controller.dart';
import 'package:chat_application_1/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  User? _user;
  String? errorMessage;

  User? get user => _user;

  Future<void> initState(context) async {}

  AuthController() {
    _checkAuthState();
  }

  
  Future<void> _checkAuthState() async {
    _user = _auth.currentUser;
    notifyListeners();
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
Future<void> logout() async {
    try {
      await _auth.signOut();
      notifyListeners(); 
    } catch (e) {
      print("Logout failed: $e");
    }
  }
  Future<void> signInWithEmailPassword(context ,String email, String password,  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = userCredential.user;
      notifyListeners();

      if (!_user!.emailVerified) {
        await _user!.sendEmailVerification();
        Utils.showPrimarySnackbar(
          context,
          "A verification link has been sent to your email. Please verify your email.",
          type: SnackType.info,
        );
        await signOut(context);
      }
    } catch (e) {
      Utils.showPrimarySnackbar(
        context,
        e.toString(),
        type: SnackType.error,
      );
      notifyListeners();
    }
  }


  // Future<void> signUpWithEmailPassword(context,String email, String password) async {
  //   try {
  //     _user = null;
  //     notifyListeners();

  //     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: emailController.text.trim(),
  //       password: passwordController.text.trim(),
  //     );

  //     _user = userCredential.user;

  //     await _user!.sendEmailVerification();
  //     Utils.showPrimarySnackbar(
  //       context,
  //       "A verification link has been sent to your email. Please verify your email.",
  //       type: SnackType.info,
  //     );
  //     await _auth.signOut();
  //     _user = null;
  //     notifyListeners();
  //   } on FirebaseAuthException catch (e) {
  //     Utils.showPrimarySnackbar(context, e.message ?? "Signup failed", type: SnackType.error);
  //     notifyListeners();
  //   }
  // }

Future<void> signUpWithEmailPassword(
    BuildContext context, String email, String password) async {
  try {
    _user = null;
    notifyListeners();

    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    _user = userCredential.user;

    if (_user != null) {
      
      final addInfoController = context.read<AddinfoController>();
      await addInfoController.saveUserDetails(
        context,
        "Default Name", 
        0,             
        "0000000000",  
      );

      await _user!.sendEmailVerification();

      Utils.showPrimarySnackbar(
        context,
        "Registration successful! A verification link has been sent to your email.",
        type: SnackType.info,
      );

      await _auth.signOut();
      _user = null; // Reset user
    }
    notifyListeners();
  } on FirebaseAuthException catch (e) {
    errorMessage = e.message ?? "Signup failed";
    Utils.showPrimarySnackbar(context, errorMessage!, type: SnackType.error);
    notifyListeners();
  }
}

  // Future<void> signOut(BuildContext context) async {
  //   await _auth.signOut();
  //   _user = null;
  //   Utils.showPrimarySnackbar(context, "Signed out successfully!", type: SnackType.info);
  //   notifyListeners();
  // }
}
