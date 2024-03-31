// ignore_for_file: prefer_const_constructors

import 'package:cookie_app/pages/community_page.dart';
import 'package:cookie_app/pages/settings_page.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../pages/home_page.dart';
import '../pages/library_page.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      CommunityPage(),
      LibraryPage(),
      SettingPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.house_alt),
        title: ("Trang Chủ"),
        activeColorPrimary: AppColors.coffee,
        activeColorSecondary: AppColors.coffee,
        inactiveColorPrimary: AppColors.grey_heavy,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          CupertinoIcons.person_2,
        ),
        title: ("Cộng Đồng"),
        activeColorPrimary: Color(0xFFB99B6B),
        activeColorSecondary: AppColors.coffee,
        inactiveColorPrimary: AppColors.grey_heavy,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.folder),
        title: ("Thư Viện"),
        activeColorPrimary: Color(0xFFB99B6B),
        activeColorSecondary: AppColors.coffee,
        inactiveColorPrimary: AppColors.grey_heavy,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.gear_alt),
        title: ("Cài Đặt"),
        activeColorPrimary: Color(0xFFB99B6B),
        activeColorSecondary: AppColors.coffee,
        inactiveColorPrimary: AppColors.grey_heavy,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;
    _controller = PersistentTabController(initialIndex: 0);

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      resizeToAvoidBottomInset: true,
      confineInSafeArea: true,
      decoration: NavBarDecoration(
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 4.0)],
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
        adjustScreenBottomPaddingOnCurve: true,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 300),
      ),
      navBarStyle:
          NavBarStyle.style3, // Choose the nav bar style with this property.
    );
  }
}
