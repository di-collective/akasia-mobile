import 'package:flutter/material.dart';

import '../../domain/entities/faq_entity.dart';
import 'answer_question_widget.dart';
import 'tips_widget.dart';

class FaqDetailWidget extends StatelessWidget {
  final FaqEntity faq;

  const FaqDetailWidget({super.key, required this.faq});

  @override
  Widget build(BuildContext context) {
    if (faq.type == null) {
      return const SizedBox.shrink();
    }

    switch (faq.type!) {
      case FaqType.questionAnswer:
        return QuestionAnswerWidget(
          faq: faq,
        );
      case FaqType.tips:
        return TipsWidget(
          faq: faq,
        );
    }
  }
}
