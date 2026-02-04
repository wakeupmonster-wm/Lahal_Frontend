import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/home/view/map_screen.dart';
import 'package:lahal_application/features/home/view/prey_screen.dart';
import 'package:lahal_application/features/home/view/profile_screen.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import '../../home/view/home_screen.dart';
import '../../profile/view/profile_screen.dart';

class BottomNavController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  // UNSELECTED + SELECTED ICONS
  final List<String> unselectedIcons = [
    AppSvg.greyHomeIcon,
    AppSvg.greyMapIcon,
    AppSvg.greyPreyIcon,
    AppSvg.greyProfileIcon,
  ];

  final List<String> selectedIcons = [
    AppSvg.greenHomeIcon,
    AppSvg.greenLocationIcon,
    AppSvg.greenPreyIcon,
    AppSvg.greenProfileIcon,
  ];

  final List<String> labels = ['Discover', 'Add', 'Pray', 'Me'];

  // SCREENS
  final List<Widget> screens = [
    HomeScreen(),
    MapScreen(),
    PreyScreen(),
    ProfileScreen(),
  ];
}
