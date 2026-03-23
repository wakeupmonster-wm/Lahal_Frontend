import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class RedirectingSnackbarController extends GetxController with GetSingleTickerProviderStateMixin {
  final VoidCallback onTimerComplete;
  
  RedirectingSnackbarController({required this.onTimerComplete});

  final RxInt counter = 6.obs;
  Timer? _timer;
  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter.value > 1) {
        counter.value--;
      } else {
        _timer?.cancel();
        onTimerComplete();
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    animationController.dispose();
    super.onClose();
  }
}

class RedirectingSnackbar extends StatelessWidget {
  final VoidCallback onTimerComplete;
  final VoidCallback onCancel;

  const RedirectingSnackbar({
    super.key,
    required this.onTimerComplete,
    required this.onCancel,
  });

  static Future<bool> show(BuildContext context) async {
    bool didComplete = false;
    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return RedirectingSnackbar(
          onTimerComplete: () {
            didComplete = true;
            Navigator.of(context).pop();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
    return didComplete;
  }

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final cs = Theme.of(context).colorScheme;

    return GetBuilder<RedirectingSnackbarController>(
      init: RedirectingSnackbarController(onTimerComplete: onTimerComplete),
      builder: (controller) {
        return Container(
          margin: EdgeInsets.all(tok.gap.md),
          padding: EdgeInsets.all(tok.gap.md),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(tok.radiusLg),
            boxShadow: [
              BoxShadow(
                color: cs.onSurface.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: controller.animationController,
                      builder: (context, child) {
                        return CircularProgressIndicator(
                          value: 1.0 - controller.animationController.value,
                          strokeWidth: 4,
                          backgroundColor: cs.outlineVariant.withOpacity(0.5),
                          valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                        );
                      },
                    ),
                    Obx(() => AppText(
                      '${controller.counter.value}',
                      size: AppTextSize.s16,
                      weight: AppTextWeight.bold,
                      color: cs.onSurface,
                    )),
                  ],
                ),
              ),
              SizedBox(width: tok.gap.md),
              Expanded(
                child: AppText(
                  'Redirecting to the maps',
                  size: AppTextSize.s16,
                  weight: AppTextWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  onCancel();
                },
                style: TextButton.styleFrom(
                  foregroundColor: cs.error,
                ),
                child: AppText(
                  'Cancel',
                  size: AppTextSize.s14,
                  weight: AppTextWeight.bold,
                  color: cs.error,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
