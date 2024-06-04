import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';
import '../../data/models/faq_model.dart';
import 'faq_details_page.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.locale.frequentlyAskedQuestions,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 40,
                horizontal: context.paddingHorizontal,
              ),
              color: colorScheme.surfaceContainerDim,
              child: Text(
                "Temukan jawaban dari pertanyaan mengenai Liposuction di sini!",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: textTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurfaceDim,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.paddingHorizontal,
              ),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: mockFaqs.map(
                  (faq) {
                    return GestureDetector(
                      onTap: () => _onFaqDetails(
                        faq: faq,
                      ),
                      child: Container(
                        width: context.width / 2.4,
                        height: context.width / 2.4,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: NetworkImageWidget(
                                fit: BoxFit.cover,
                                imageUrl: faq.imageUrl,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                faq.title ?? '',
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                style: textTheme.labelMedium.copyWith(
                                  color: colorScheme.surfaceContainerBright,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
            SizedBox(
              height: context.paddingBottom,
            ),
          ],
        ),
      ),
    );
  }

  void _onFaqDetails({
    required FaqModel faq,
  }) {
    // go to faq details page
    context.goNamed(
      AppRoute.faqDetails.name,
      extra: FaqDetailsPageParams(
        faq: faq,
      ),
    );
  }
}
