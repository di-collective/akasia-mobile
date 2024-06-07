import '../../domain/entities/faq_entity.dart';
import 'faq_detail_model.dart';

class FaqModel extends FaqEntity {
  const FaqModel({
    super.title,
    super.imageUrl,
    super.type,
    super.faqDetails,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      title: json['title'],
      imageUrl: json['image_url'],
      type: json['type'],
      faqDetails: (json['faq_details'] is List)
          ? (json['faq_details'] as List).map((e) {
              return FaqDetailModel.fromJson(e);
            }).toList()
          : null,
    );
  }
}
