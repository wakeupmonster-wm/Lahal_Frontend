import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';

class PreyScreen extends StatelessWidget {
  const PreyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(child: Text("Prey Screen"))],
      ),
    );
  }
}
