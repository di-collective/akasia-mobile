import 'package:equatable/equatable.dart';

import 'faq_detail_entity.dart';

enum FaqType {
  questionAnswer,
  tips,
}

class FaqEntity extends Equatable {
  final String? title;
  final String? imageUrl;
  final FaqType? type;
  final List<FaqDetailEntity>? faqDetails;

  const FaqEntity({
    this.title,
    this.imageUrl,
    this.type,
    this.faqDetails,
  });

  @override
  List<Object?> get props => [
        title,
        imageUrl,
        type,
        faqDetails,
      ];
}
