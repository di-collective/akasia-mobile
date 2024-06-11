import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../widgets/article_recomendations_widget.dart';
import '../widgets/events_widget.dart';
import '../widgets/help_center_widget.dart';
import '../widgets/promotions_widget.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.locale.info,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: context.paddingTop,
            ),
            const HelpCenterWidget(),
            const SizedBox(
              height: 32,
            ),
            const PromotionsWidget(),
            const SizedBox(
              height: 22,
            ),
            const ArticleRecomendationsWidget(),
            const SizedBox(
              height: 32,
            ),
            const EventsWidget(),
            SizedBox(
              height: context.paddingBottom,
            ),
          ],
        ),
      ),
    );
  }
}
