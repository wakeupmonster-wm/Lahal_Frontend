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
      // Dummy data as per image for now
      final dummyFaqs = [
        FaqModel(
          question: "What is Match At First Swipe?",
          answer:
              "Match At First Swipe is a dating app designed to help you meet new people, make meaningful connections, and find potential matches based on your interests and preferences.",
        ),
        FaqModel(
          question: "How do I create a Match At First Swipe account?",
          answer:
              "To create an account, download the app, open it, and follow the registration steps using your phone number or social login options.",
        ),
        FaqModel(
          question: "Is Match At First Swipe free to use?",
          answer:
              "Yes, the basic version of the app is free to use. We also offer premium features for a better experience.",
        ),
        FaqModel(
          question: "How does matching work on Match At First Swipe?",
          answer:
              "Matching works by analyzing your profile and preferences to show you compatible users. Swipe right to like and left to pass.",
        ),
        FaqModel(
          question: "Can I change my location on Match At First Swipe?",
          answer:
              "Yes, you can change your location in the profile settings section of the app.",
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
