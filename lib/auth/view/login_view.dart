
import 'package:chat_application_1/auth/controller/login_controller.dart';
import 'package:chat_application_1/user_info/view/add_user_information.dart';
import 'package:chat_application_1/utils/utils.dart';
import 'package:chat_application_1/widgets/button.dart';
import 'package:chat_application_1/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<AuthController>().initState(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final watch = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage("assets/images/text_only_image.png"),
              height: 130.w,
              width: 130.w,
              fit: BoxFit.contain,
            ),
            PrimarySTextFormField(
              controller: watch.emailController,
              titleHeader: "Email",
              hintText: "Please Enter Email",
              hintFontSize: 14.sp,
            ),
            SizedBox(height: 10.h),
            PrimarySTextFormField(
              controller: watch.passwordController,
              titleHeader: 'Password',
              preffix: Icon(Icons.lock_outline),
              suffix: Icon(Icons.visibility_off_outlined),
              hintText: "Please Enter Password",
              hintFontSize: 14.sp,
              isPasswordField: true,
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (watch.errorMessage != null)
              Text(
                watch.errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20),
            PrimaryButton(
              fontSize: 50.sp,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 220, 253, 253),
              onTap: () async {
                String email = watch.emailController.text;
                String password = watch.passwordController.text;

                await watch.signInWithEmailPassword(context,email, password);
                if (watch.user != null) {
                  if (watch.user!.emailVerified) {
                    Utils.showPrimarySnackbar(context, "Login successful!",
                        type: SnackType.success);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => UserDetailsPage()),
                    );
                  } else {
                    Utils.showPrimarySnackbar(context, "Please verify your email.",
                        type: SnackType.error);
                  }
                } else if (watch.errorMessage != null) {
                  Utils.showPrimarySnackbar(context, watch.errorMessage!,
                      type: SnackType.error);
                }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            PrimaryButton(
              fontSize: 50.sp,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 220, 253, 253),
              onTap: () async {
                String email = watch.emailController.text;
                String password = watch.passwordController.text;

                await watch.signUpWithEmailPassword(context, email, password);

                if (watch.errorMessage != null) {
                  Utils.showPrimarySnackbar(context, watch.errorMessage!,
                      type: SnackType.error);
                } else {
                  Utils.showPrimarySnackbar(context,
                      "Registration successful! Please verify your email.",
                      type: SnackType.success);
                }
              },
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
