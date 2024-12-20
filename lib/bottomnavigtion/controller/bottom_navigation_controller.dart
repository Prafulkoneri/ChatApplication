import 'dart:async';
import 'package:chat_application_1/profile/view/profile_view.dart';
import 'package:chat_application_1/user_list/view/user_list_view.dart';
import 'package:flutter/material.dart';


class MainScreenController extends ChangeNotifier {
  int currentIndex = 0;
  int currentTab = 0;
  int cartCount = 0;
  bool stackLoaderVisible = false;
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen =  UserListScreen();
  bool hideBottomNavigation = false;

  void initState(
    context,
    index,
    currentScreen,
  ) async {
    notifyListeners();
  }

  onNavigation(index, screen, context) {
    currentScreen = screen;
    currentTab = index;
    notifyListeners();
  }

  void onBottomNavChanged(index) {
    currentIndex = index;
    notifyListeners();
  }

  showStackLoader(value) {
    stackLoaderVisible = value;
    notifyListeners();
  }

  void onHomeScreenPressed() {
    currentTab = 0;
    currentScreen =  UserListScreen();
    notifyListeners();
  }

  showBottomNavigationBar() {
    hideBottomNavigation = false;
    notifyListeners();
  }

  hideBottomNavigationBar() {
    hideBottomNavigation = true;
    notifyListeners();
  }


  void onProfilePressed() {
    currentTab = 1;
    currentScreen =  UserProfilePage();
    notifyListeners();
  }

  Future<void> navigation(tabIndex, screenName) async {
    print("${tabIndex}tabIndex");
    currentTab = tabIndex;
    currentScreen = screenName;
    notifyListeners();
  }
}
