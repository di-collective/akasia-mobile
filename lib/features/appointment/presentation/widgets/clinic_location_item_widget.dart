import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
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

    final borderColor =
        isSelected ? colorScheme.primaryTonal : colorScheme.surfaceDim;
    final backgroundColor =
        isSelected ? colorScheme.primaryTonal : colorScheme.white;
    final textColor = isSelected ? colorScheme.primary : colorScheme.onSurface;

    return ButtonWidget(
      text: clinicLocation.name?.toCapitalize() ?? '',
      borderColor: borderColor,
      backgroundColor: backgroundColor,
      style: textTheme.bodyLarge.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      onTap: onTap,
    );
  }
}
