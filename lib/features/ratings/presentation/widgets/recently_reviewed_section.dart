import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import 'review_empty_content.dart';

class RecentlyReviewedSection extends StatefulWidget {
  const RecentlyReviewedSection({super.key});

  @override
  State<RecentlyReviewedSection> createState() => _RecentlyReviewedSectionState();
}

class _RecentlyReviewedSectionState extends State<RecentlyReviewedSection> {
  @override
  Widget build(BuildContext context) {
    return ReviewEmptyContent(
      info: context.locale.thereAreNoPost,
    );
  }
}
