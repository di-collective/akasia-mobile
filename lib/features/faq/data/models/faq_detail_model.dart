import '../../domain/entities/faq_detail_entity.dart';

class FaqDetailModel extends FaqDetailEntity {
  const FaqDetailModel({
    super.title,
    super.description,
    super.items,
  });

  factory FaqDetailModel.fromJson(Map<String, dynamic> json) {
    return FaqDetailModel(
      title: json['title'],
      description: json['description'],
      items: (json['items'] is List)
          ? List<String?>.from(
              json['items'],
            )
          : null,
    );
  }
}
