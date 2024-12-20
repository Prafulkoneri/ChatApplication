import 'dart:io';

import 'package:chat_application_1/user_info/controller/add_info_controller.dart';
import 'package:chat_application_1/user_list/view/user_list_view.dart';
import 'package:chat_application_1/utils/utils.dart';
import 'package:chat_application_1/widgets/button.dart';
import 'package:chat_application_1/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat_application_1/bottomnavigtion/view/bottom_naviagtion_view.dart';
import 'package:provider/provider.dart';
import 'package:chat_application_1/auth/controller/login_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserDetailsPage extends StatefulWidget {
  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final watchAuth = Provider.of<AuthController>(context);
    final watch = Provider.of<AddinfoController>(context);
    final read = Provider.of<AddinfoController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Complete Profile"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the email address
            Text(
              "Email: ${watchAuth.user?.email ?? 'Not Available'}",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            SizedBox(height: 20),
            PrimarySTextFormField(
              controller: watch.nameController,
              titleHeader: "Name",
              hintText: "Please Enter Name",
              hintFontSize: 14.sp,
            ),
            SizedBox(height: 10.h),

            PrimarySTextFormField(
              textInputType: TextInputType.number,
              controller: watch.ageController,
              titleHeader: "Age",
              hintText: "Please Enter Age",
              hintFontSize: 14.sp,
            ),
            SizedBox(height: 10.h),
            PrimarySTextFormField(
              textInputType: TextInputType.number,
              controller: watch.phoneController,
              titleHeader: "Phone Number",
              hintText: "Please Enter Phone Number",
              hintFontSize: 14.sp,
            ),

            SizedBox(height: 20),

            // Save button
            PrimaryButton(
  fontSize: 50.sp,
  fontWeight: FontWeight.bold,
  color: const Color.fromARGB(255, 220, 253, 253),
  onTap: () async {
    String name = watch.nameController.text;
    int age = int.tryParse(watch.ageController.text) ?? 0;
    String phone = watch.phoneController.text;

    await read.saveUserDetails(context, name, age, phone);

    Utils.showPrimarySnackbar(
      context,
      "Profile saved successfully!",
      type: SnackType.success,
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreenView(
          index: 0,
          screenName: UserListScreen(),
        ),
      ),
      (Route<dynamic> route) => false,
    );
  },
  child: Text("Save"),
),

            // PrimaryButton(
            //   fontSize: 50.sp,
            //   fontWeight: FontWeight.bold,
            //   color: const Color.fromARGB(255, 220, 253, 253),
            //   onTap: () async {
            //     String name = watch.nameController.text;
            //     int age = int.tryParse(watch.ageController.text) ?? 0;
            //     String phone = watch.phoneController.text;

            //     if (watchAuth.errorMessage == null) {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(content: Text("Profile saved successfully!")),
            //       );
            //       Navigator.pushAndRemoveUntil(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => MainScreenView(
            //             index: 0,
            //             screenName: UserListScreen(),
            //           ),
            //         ),
            //         (Route<dynamic> route) => false,
            //       );
            //     } else {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(content: Text(watchAuth.errorMessage!)),
            //       );
            //     }
            //   },
            //   child: Text("Save"),
            // ),
          ],
        ),
      ),
    );
  }
}
