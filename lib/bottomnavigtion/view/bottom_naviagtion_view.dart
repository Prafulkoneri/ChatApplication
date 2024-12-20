
import 'package:chat_application_1/bottomnavigtion/controller/bottom_navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class MainScreenView extends StatefulWidget {
  final Widget? screenName;
  final int? index;
  const MainScreenView(
      {Key? key,  this.screenName, this.index})
      : super(key: key);

  @override
  _MainScreenViewState createState() => _MainScreenViewState();
}

class _MainScreenViewState extends State<MainScreenView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
          });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<MainScreenController>().initState(
            context,
            widget.index,
            widget.screenName,
          );
    });
  }

  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final read = context.read<MainScreenController>();
    final watch = context.watch<MainScreenController>();
    return Scaffold(
        extendBody: true,
        bottomNavigationBar: Visibility(
          visible: !watch.hideBottomNavigation ? true : false,
          child: Container(
              height: 85.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.w),
                    topLeft: Radius.circular(30.w)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 2),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
                child: BottomAppBar(
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 35.w, right: 35.w, top: 16.w),
                    height: 70.w,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            read.onHomeScreenPressed();
                          },
                          child: watch.currentTab == 0
                              ? Container(
                                  padding:
                                      EdgeInsets.only(left: 2.w, right: 2.w),
                                  color: Colors.transparent,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20.w,
                                        width: 21.w,
                                        child:  Icon(Icons.home,color: Colors.red),
                                                
                                      ),
                                      SizedBox(
                                        height: 5.w,
                                      ),
                                      Text(
                                        "Home",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 11.sp,
                                            color: Colors.red),
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  padding:
                                      EdgeInsets.only(left: 2.w, right: 2.w),
                                  color: Colors.transparent,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20.w,
                                        width: 21.w,
                                        child: Icon(Icons.home,),
                                      ),
                                      SizedBox(
                                        height: 5.w,
                                      ),
                                      Text(
                                        "Home",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 11.sp,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                        ),
                      
                        GestureDetector(
                          onTap: () {
                            read.onProfilePressed();
                          },
                          child: watch.currentTab == 1
                              ? Container(
                                  color: Colors.transparent,
                                  padding:
                                      EdgeInsets.only(left: 2.w, right: 2.w),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20.w,
                                        width: 21.w,
                                        child: Icon(Icons.person, color: Colors.red),
                                      ),
                                      SizedBox(
                                        height: 5.w,
                                      ),
                                      Text(
                                        "Account",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 11.sp,
                                            color: Colors.red),
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  color: Colors.transparent,
                                  padding:
                                      EdgeInsets.only(left: 2.w, right: 2.w),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20.w,
                                        width: 21.w,
                                        child: Icon(Icons.person,),
                                      ),
                                      SizedBox(
                                        height: 5.w,
                                      ),
                                      Text(
                                        "Account",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 11.sp),
                                      )
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ),
        body: watch.currentScreen
       

        );
  }
}
