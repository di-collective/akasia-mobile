import 'package:flutter/material.dart';

import 'review_item_widget.dart';

class ReviewListSection extends StatefulWidget {
  final double? topPadding;
  final List<ReviewItemWidget> items;

  const ReviewListSection({
    super.key,
    this.topPadding,
    required this.items,
  });

  @override
  State<ReviewListSection> createState() => _ReviewListSectionState();
}

class _ReviewListSectionState extends State<ReviewListSection>
    with AutomaticKeepAliveClientMixin<ReviewListSection> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: widget.items.length,
      padding: EdgeInsets.only(top: widget.topPadding ?? 0),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final itemWidget = widget.items[index];
        return itemWidget is ReviewItemCard
            ? Padding(
                padding: index == widget.items.length - 1
                    ? const EdgeInsets.all(16)
                    : const EdgeInsets.only(
                        top: 16,
                        right: 16,
                        left: 16,
                      ),
                child: itemWidget,
              )
            : itemWidget;
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
