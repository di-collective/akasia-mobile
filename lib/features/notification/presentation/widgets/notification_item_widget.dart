import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationEntity notification;
  final Function(NotificationEntity) onTap;

  const NotificationItemWidget({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return InkWell(
      onTap: () => onTap(notification),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: context.paddingHorizontal,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              AssetIconsPath.icNotificationItem,
              height: 34,
            ),
            const SizedBox(
              width: 13,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title?.toCapitalize() ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.labelLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurfaceDim,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: context.width * 0.22,
                        ),
                        child: Text(
                          notification.date ?? '',
                          style: textTheme.bodySmall.copyWith(
                            color: colorScheme.onSurfaceBright,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    notification.description?.toCapitalize() ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
