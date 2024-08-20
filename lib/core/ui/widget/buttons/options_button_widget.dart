import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../config/asset_path.dart';
import '../../theme/color_scheme.dart';
import '../../theme/dimens.dart';
import '../../theme/text_theme.dart';

class OptionButtonItem {
  final String label;
  final String? description;
  final bool? isHideArrowIcon;
  final Function() onTap;
  final bool? isDisabled;

  OptionButtonItem({
    required this.label,
    this.description,
    this.isHideArrowIcon,
    required this.onTap,
    this.isDisabled,
  });
}

class OptionsButtonWidget extends StatelessWidget {
  final List<OptionButtonItem> items;

  const OptionsButtonWidget({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemBuilder: (context, index) {
        final item = items[index];
        final borderRadius = BorderRadius.vertical(
          top: Radius.circular(
            index == 0 ? AppRadius.large : 0,
          ),
          bottom: Radius.circular(
            index == items.length - 1 ? AppRadius.large : 0,
          ),
        );

        return _ItemWidget(
          title: item.label,
          borderRadius: borderRadius,
          label: item.label,
          description: item.description,
          isHideArrowIcon: item.isHideArrowIcon,
          onTap: item.onTap,
          isDisabled: item.isDisabled,
        );
      },
    );
  }
}

class _ItemWidget extends StatefulWidget {
  final String title;
  final BorderRadius? borderRadius;
  final String label;
  final String? description;
  final bool? isHideArrowIcon;
  final bool? isDisabled;

  final Function() onTap;

  const _ItemWidget({
    required this.title,
    this.borderRadius,
    required this.label,
    this.description,
    this.isHideArrowIcon,
    required this.onTap,
    required this.isDisabled,
  });

  @override
  State<_ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<_ItemWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Material(
      color: (widget.isDisabled == true)
          ? colorScheme.surfaceDim
          : colorScheme.white,
      borderRadius: widget.borderRadius,
      child: InkWell(
        onTap: widget.isDisabled == true ? null : widget.onTap,
        borderRadius: widget.borderRadius,
        child: Container(
          padding: const EdgeInsets.all(16),
          width: context.width,
          child: _buildChild(
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ),
      ),
    );
  }

  Widget _buildChild({
    required AppColorScheme colorScheme,
    required AppTextTheme textTheme,
  }) {
    Widget? descriptionWidget;
    if (widget.description != null) {
      descriptionWidget = Text(
        widget.description!,
        textAlign: TextAlign.end,
        maxLines: 3,
        style: textTheme.bodyMedium.copyWith(
          color: colorScheme.onSurfaceDim,
        ),
      );
    }

    Widget? iconWidget;
    if (widget.isHideArrowIcon != true) {
      iconWidget = SvgPicture.asset(
        AssetIconsPath.icChevronRight,
        colorFilter: ColorFilter.mode(
          colorScheme.onSurfaceBright,
          BlendMode.srcIn,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: (descriptionWidget != null)
                ? context.width * 0.4
                : context.width,
          ),
          child: Text(
            widget.title,
            maxLines: 3,
            style: textTheme.bodyMedium.copyWith(
              color: colorScheme.onSurfaceDim,
            ),
          ),
        ),
        if (descriptionWidget != null) ...[
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: descriptionWidget,
          ),
        ],
        if (iconWidget != null) ...[
          const SizedBox(
            width: 8,
          ),
          iconWidget,
        ],
      ],
    );
  }
}
