import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../domain/entities/clinic_location_entity.dart';

class ClinicLocationItemWidget extends StatelessWidget {
  final ClinicLocationEntity clinicLocation;
  final bool isSelected;
  final Function() onTap;

  const ClinicLocationItemWidget({
    super.key,
    required this.clinicLocation,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return ButtonWidget(
      text: clinicLocation.name ?? '',
      borderColor:
          isSelected ? colorScheme.primaryTonal : colorScheme.surfaceDim,
      backgroundColor:
          isSelected ? colorScheme.primaryTonal : colorScheme.white,
      style: textTheme.bodyLarge.copyWith(
        color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      onTap: onTap,
    );
  }
}
