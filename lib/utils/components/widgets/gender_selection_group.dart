import 'package:flutter/material.dart';
import 'package:lahal_application/utils/components/widgets/gender_selection_tile.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';

class GenderSelectionGroup extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String> onGenderSelected;
  final List<String> genders;

  const GenderSelectionGroup({
    super.key,
    required this.selectedGender,
    required this.onGenderSelected,
    this.genders = const [
      'Man',
      'Woman',
      'Non-binary',
      'Trans Man',
      'Trans Woman',
      'Genderqueer',
    ],
  });

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;

    return Column(
      children: List.generate(genders.length, (index) {
        final gender = genders[index];
        return Column(
          children: [
            GenderSelectionTile(
              label: gender,
              isSelected: selectedGender == gender,
              onTap: () => onGenderSelected(gender),
            ),
            if (index < genders.length - 1) SizedBox(height: tok.gap.sm),
          ],
        );
      }),
    );
  }
}
