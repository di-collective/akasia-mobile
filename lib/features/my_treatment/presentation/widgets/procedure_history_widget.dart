import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/states/state_empty_widget.dart';

class ProcedureHistoryWidget extends StatefulWidget {
  final List? procedureHistories;

  const ProcedureHistoryWidget({
    super.key,
    required this.procedureHistories,
  });

  @override
  State<ProcedureHistoryWidget> createState() => _ProcedureHistoryWidgetState();
}

class _ProcedureHistoryWidgetState extends State<ProcedureHistoryWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.locale
                    .historyItem(
                      context.locale.procedure,
                    )
                    .toCapitalizes(),
                style: textTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurfaceDim,
                ),
                maxLines: 2,
              ),
            ),
            if (widget.procedureHistories != null &&
                widget.procedureHistories!.isNotEmpty) ...[
              const SizedBox(
                width: 8,
              ),
              GestureDetector(
                onTap: _onViewAllProcedure,
                child: Text(
                  context.locale.viewAll,
                  style: textTheme.labelMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          width: context.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: (widget.procedureHistories != null &&
                  widget.procedureHistories!.isNotEmpty)
              ? ListView.separated(
                  itemCount: widget.procedureHistories!.length > 3
                      ? 3
                      : widget.procedureHistories!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  primary: false,
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemBuilder: (context, index) {
                    return Padding(
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
                    );
                  },
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: StateEmptyWidget(
                    buttonText: context.locale.createItem(
                      context.locale.appointment,
                    ),
                    onTapButton: _onCreateAppointment,
                  ),
                ),
        ),
      ],
    );
  }

  void _onViewAllProcedure() {
    // TODO: implement _onViewAllProcedure
  }

  void _onCreateAppointment() {
    // TODO: implement _onCreateAppointment
  }

  void _onProcedure() {
    // TODO: implement _onProcedure
  }
}
