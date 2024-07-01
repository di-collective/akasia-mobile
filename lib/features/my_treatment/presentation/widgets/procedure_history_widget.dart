import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/states/state_empty_widget.dart';
import 'procedure_item_widget.dart';

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
                    return ProcedureItemWidget(
                      onTap: _onProcedure,
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
    // go to create appointment page
    context.goNamed(
      AppRoute.createAppointment.name,
    );
  }

  void _onProcedure() {
    // TODO: implement _onProcedure
  }
}
