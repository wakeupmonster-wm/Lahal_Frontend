import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/profile/model/faq_model.dart';
import 'package:lahal_application/features/profile/repo/profile_repository.dart';

class FaqController extends GetxController {
  final ProfileRepository _profileRepo = ProfileRepository();

  final searchController = TextEditingController();
  final RxList<FaqModel> allFaqs = <FaqModel>[].obs;
  final RxList<FaqModel> filteredFaqs = <FaqModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFaqs();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void fetchFaqs() async {
    isLoading.value = true;
    try {
      // Dummy data relevant to the Lahal restaurant finder app
      final dummyFaqs = [
        FaqModel(
          question: "What is Lalah?",
          answer:
              "Lalah is a premium restaurant finder and food delivery app designed to help you discover the best dining spots around you, explore menus, and order food easily.",
        ),
        FaqModel(
          question: "How do I search for a specific restaurant or cuisine?",
          answer:
              "Use the search bar on the Home Screen to type in the name of a restaurant or a dish (e.g., 'Pizza', 'Burger', 'Biryani'). You can also use the Filter option to narrow down by cuisine, rating, and distance.",
        ),
        FaqModel(
          question: "How does the filter feature work?",
          answer:
              "Tap the filter icon next to the search bar. You can adjust the distance range, select a minimum star rating, and choose specific cuisines to find exactly what you're craving.",
        ),
        FaqModel(
          question: "How can I save my favorite restaurants?",
          answer:
              "Simply tap the heart icon on any restaurant card. It will be added to your Favorites list, which you can easily access from your profile section.",
        ),
        FaqModel(
          question: "Can I see where a restaurant is located?",
          answer:
              "Yes! You can view restaurants on the interactive Map Screen to see their exact location relative to you and plan your visit accordingly.",
        ),
      ];

      allFaqs.assignAll(dummyFaqs);
      filteredFaqs.assignAll(dummyFaqs);

      // If API was ready:
      // final response = await _profileRepo.getFaqs();
      // ... process response ...
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch(String query) {
    if (query.isEmpty) {
      filteredFaqs.assignAll(allFaqs);
    } else {
      filteredFaqs.assignAll(
        allFaqs
            .where(
              (faq) =>
                  faq.question.toLowerCase().contains(query.toLowerCase()) ||
                  faq.answer.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
  }

  void toggleExpansion(int index) {
    filteredFaqs[index].isExpanded = !filteredFaqs[index].isExpanded;
    filteredFaqs.refresh();
  }
}
