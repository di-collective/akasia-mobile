import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';
import '../../domain/entities/faq_entity.dart';
import '../widgets/faq_detail_widget.dart';

class FaqDetailsPageParams {
  final FaqEntity faq;

  const FaqDetailsPageParams({
    required this.faq,
  });
}

class FaqDetailsPage<T> extends StatefulWidget {
  final T? params;

  const FaqDetailsPage({
    super.key,
    this.params,
  });

  @override
  State<FaqDetailsPage> createState() => _FaqDetailsPageState();
}

class _FaqDetailsPageState extends State<FaqDetailsPage> {
  FaqEntity? _faq;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    if (widget.params is FaqDetailsPageParams) {
      final params = widget.params as FaqDetailsPageParams;

      _faq = params.faq;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    if (_faq == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.locale.frequentlyAskedQuestions,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: context.paddingTop,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.paddingHorizontal,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _faq?.title ?? '',
                          maxLines: 5,
                          style: textTheme.headlineLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurfaceDim,
                          ),
                        ),
                        Container(
                          width: 43,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  NetworkImageWidget(
                    imageUrl: _faq?.imageUrl,
                    size: const Size(
                      120,
                      120,
                    ),
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            FaqDetailWidget(
              faq: _faq!,
            ),
            SizedBox(
              height: context.paddingBottom,
            ),
          ],
        ),
      ),
    );
  }
}
