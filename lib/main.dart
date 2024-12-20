import 'package:chat_application_1/bottomnavigtion/controller/bottom_navigation_controller.dart';
import 'package:chat_application_1/bottomnavigtion/view/bottom_naviagtion_view.dart';
import 'package:chat_application_1/chat/controller/chat_controller.dart';
import 'package:chat_application_1/auth/controller/login_controller.dart';
import 'package:chat_application_1/profile/controller/profile_controller.dart';
import 'package:chat_application_1/profile/view/profile_view.dart';
import 'package:chat_application_1/user_info/controller/add_info_controller.dart';
import 'package:chat_application_1/user_list/controller/user_list_view_controller.dart';
import 'package:chat_application_1/auth/view/login_view.dart';
import 'package:chat_application_1/user_list/view/user_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main()async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => MainScreenController()),
        ChangeNotifierProvider(create: (_) => ChatController()),
        ChangeNotifierProvider(create: (_) => UserListController()),
        ChangeNotifierProvider(create: (_) => AddinfoController()),
        ChangeNotifierProvider(create: (_) => UserProfileController()),
     
      ],
      child:  MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
        final authController = Provider.of<AuthController>(context);

    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize:  Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Chat Aliction',
             
      home: authController.user != null
          ? MainScreenView(
              index: 0, // Set your desired default index here
              screenName: UserListScreen(),
            )
          : LoginView(),);
        });
  }
}

