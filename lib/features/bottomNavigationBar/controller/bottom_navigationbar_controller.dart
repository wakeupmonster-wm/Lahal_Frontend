import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    AppSvg.home,
    // AppSvg.match,
    // AppSvg.fwb,
    // AppSvg.chat,
    AppSvg.profile,
  ];

  final List<String> selectedIcons = [
    AppSvg.homeSelected,
    // AppSvg.matchSelected,
    // AppSvg.fwbSelected,
    // AppSvg.chatSelected,
    AppSvg.profileSelected,
  ];

  // SCREENS
  final List<Widget> screens = [
    // HomeScreen(),
    // MatchesScreen(),
    // BenefitsScreen(),
    // ChatsScreen(),
    // ProfileScreen(),
  ];
}
