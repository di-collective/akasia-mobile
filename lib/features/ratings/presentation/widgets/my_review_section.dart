import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import 'review_empty_content.dart';

class MyReviewSection extends StatefulWidget {
  const MyReviewSection({super.key});

  @override
  State<MyReviewSection> createState() => _MyReviewSectionState();
}

class _MyReviewSectionState extends State<MyReviewSection> {
  @override
  Widget build(BuildContext context) {
    return ReviewEmptyContent(
      info: context.locale.thereAreNoPost,
    );
  }
}
