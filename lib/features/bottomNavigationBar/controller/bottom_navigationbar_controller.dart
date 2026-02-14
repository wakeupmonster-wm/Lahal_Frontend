import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/home/view/screens/prey_screen.dart';
import 'package:lahal_application/features/profile/view/screens/profile_screen.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/features/add_restaurant/view/screen/add_restaurant_screen.dart';
import '../../home/view/screens/home_screen.dart';

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
    AddRestaurantScreen(),
    PreyScreen(),
    ProfileScreen(),
  ];
}
