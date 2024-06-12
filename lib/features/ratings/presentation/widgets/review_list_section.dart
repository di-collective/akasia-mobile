import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import 'review_item_widget.dart';

class ReviewListSection extends StatefulWidget {
  final double? topPadding;
  final List<ReviewItemWidget> items;
  final Future<void> Function() onFetchNewReviews;
  final int nextPage;
  final bool isLastPage;

  const ReviewListSection({
    super.key,
    this.topPadding,
    required this.items,
    required this.onFetchNewReviews,
    required this.nextPage,
    required this.isLastPage,
  });

  @override
  State<ReviewListSection> createState() => _ReviewListSectionState();
}

class _ReviewListSectionState extends State<ReviewListSection>
    with AutomaticKeepAliveClientMixin<ReviewListSection> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final isScrolledToEnd = _controller.position.maxScrollExtent == _controller.offset;
      if (isScrolledToEnd) {
        _onFetchNewReviews();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColorScheme;
    super.build(context);
    return ListView.builder(
      controller: _controller,
      itemCount: widget.items.length + 1,
      padding: EdgeInsets.only(
        top: widget.topPadding ?? 0,
        bottom: context.mediaQuery.padding.bottom,
      ),
      shrinkWrap: true,
      findChildIndexCallback: (key) {
        return (key as ValueKey<int>).value;
      },
      itemBuilder: (context, index) {
        final key = ValueKey<int>(index);
        if (index < widget.items.length) {
          final itemWidget = widget.items[index];
          return itemWidget is ReviewItemCard
              ? Padding(
                  key: key,
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
        } else {
          return widget.isLastPage
              ? SizedBox(
                  key: key,
                  height: 0,
                )
              : Padding(
                  key: key,
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: colors.primary,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _onFetchNewReviews() async {
    if (widget.isLastPage) return;
    await widget.onFetchNewReviews();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
