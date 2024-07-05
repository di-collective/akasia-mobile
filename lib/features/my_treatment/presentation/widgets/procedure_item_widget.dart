import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class ProcedureItemWidget extends StatelessWidget {
  final Function() onTap;

  const ProcedureItemWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "*Nama Dokter*",
                    style: textTheme.bodyMedium.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Jenis Treatment",
                    style: textTheme.bodyMedium.copyWith(
                      color: colorScheme.onSurfaceDim,
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Row(
              children: [
                Text(
                  "4 Mar",
                  style: textTheme.bodyMedium.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                SvgPicture.asset(
                  AssetIconsPath.icChevronRight,
                  height: 10,
                  colorFilter: ColorFilter.mode(
                    colorScheme.onSurfaceBright,
                    BlendMode.srcIn,
                  ),
                )
              ],
            ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
  }
}
