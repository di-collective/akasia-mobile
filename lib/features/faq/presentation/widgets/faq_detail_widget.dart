import 'package:flutter/material.dart';

import '../../data/models/faq_model.dart';
import 'answer_question_widget.dart';
import 'tutorial_widget.dart';

class FaqDetailWidget extends StatelessWidget {
  final FaqModel faq;

  const FaqDetailWidget({super.key, required this.faq});

  @override
  Widget build(BuildContext context) {
    switch (faq.type!) {
      case FaqType.questionAnswer:
        return QuestionAnswerWidget(
          faq: faq,
        );
      case FaqType.tutorials:
        return TutorialsWidget(
          faq: faq,
        );
    }
  }
}
