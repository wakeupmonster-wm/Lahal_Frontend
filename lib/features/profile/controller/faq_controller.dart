import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/profile/model/faq_model.dart';
import 'package:lahal_application/features/profile/repo/profile_repository.dart';
import 'package:lahal_application/features/profile/services/profile_api_service.dart';
import 'package:lahal_application/features/profile/services/faq_service.dart';

class FaqController extends GetxController {
  late final FaqService _faqService;

  final searchController = TextEditingController();
  final RxList<FaqModel> allFaqs = <FaqModel>[].obs;
  final RxList<FaqModel> filteredFaqs = <FaqModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    // Register dependencies
    if (!Get.isRegistered<ProfileRepository>()) Get.put(ProfileRepository());
    if (!Get.isRegistered<ProfileApiService>()) Get.put(ProfileApiService());
    if (!Get.isRegistered<FaqService>()) Get.put(FaqService());

    _faqService = Get.find<FaqService>();

    // Link hasError to errorMessage for compatibility
    ever(errorMessage, (msg) => hasError.value = msg.isNotEmpty);

    fetchFaqs();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void fetchFaqs() {
    _faqService.loadFaqs(
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (faqs) {
        allFaqs.assignAll(faqs);
        filteredFaqs.assignAll(faqs);
      },
      onError: (error) {
        // Error is already set in errorMessage via ApiCallHandler
      },
    );
  }

  void onSearch(String query) {
    final trimmedQuery = query.trim().toLowerCase();

    if (trimmedQuery.isEmpty) {
      filteredFaqs.assignAll(allFaqs);
    } else {
      filteredFaqs.assignAll(
        allFaqs
            .where(
              (faq) =>
                  faq.question.toLowerCase().contains(trimmedQuery) ||
                  faq.answer.toLowerCase().contains(trimmedQuery),
            )
            .toList(),
      );
    }
  }

  void clearSearch() {
    searchController.clear();
    onSearch("");
  }

  void toggleExpansion(int index) {
    filteredFaqs[index].isExpanded = !filteredFaqs[index].isExpanded;
    filteredFaqs.refresh();
  }
}
