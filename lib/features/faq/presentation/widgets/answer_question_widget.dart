import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../domain/entities/faq_detail_entity.dart';
import '../../domain/entities/faq_entity.dart';

class QuestionAnswerWidget extends StatefulWidget {
  final FaqEntity faq;

  const QuestionAnswerWidget({
    super.key,
    required this.faq,
  });

  @override
  State<QuestionAnswerWidget> createState() => _QuestionAnswerWidgetState();
}

class _QuestionAnswerWidgetState extends State<QuestionAnswerWidget> {
  final List<ExpandedItem<FaqDetailEntity>> _details = [];

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    if (widget.faq.faqDetails != null) {
      for (final faqDetail in widget.faq.faqDetails!) {
        _details.add(
          ExpandedItem<FaqDetailEntity>(
            value: faqDetail,
            isExpanded: false,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return ExpansionPanelList(
      expandedHeaderPadding: EdgeInsets.zero,
      elevation: 0,
      expansionCallback: (index, isExpanded) {
        setState(() {
          _details[index].isExpanded = isExpanded;
        });
      },
      dividerColor: Colors.transparent,
      children: _details.map((detail) {
        return ExpansionPanel(
          backgroundColor: Colors.transparent,
          canTapOnHeader: true,
          isExpanded: detail.isExpanded,
          headerBuilder: (context, isExpanded) {
            return GestureDetector(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: context.paddingHorizontal,
                    ),
                    Container(
                      width: 17,
                      height: 17,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isExpanded
                            ? colorScheme.primary
                            : colorScheme.surfaceContainerDim,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Text(
                        detail.value.title ?? '',
                        maxLines: 10,
                        style: textTheme.labelLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isExpanded
                              ? colorScheme.primary
                              : colorScheme.onSurfaceDim,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          body: GestureDetector(
            onTap: () {
              setState(() {
                detail.isExpanded = !detail.isExpanded;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(
                left: context.paddingHorizontal + 33,
                right: context.paddingHorizontal,
              ),
              child: Text(
                detail.value.description ?? '',
                maxLines: 100,
                style: textTheme.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ExpandedItem<T> {
  ExpandedItem({
    required this.value,
    this.isExpanded = false,
  });

  T value;
  bool isExpanded;
}
