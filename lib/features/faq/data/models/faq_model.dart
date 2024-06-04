import 'package:equatable/equatable.dart';

import 'faq_detail_model.dart';

enum FaqType {
  questionAnswer,
  tutorials,
}

class FaqModel extends Equatable {
  final String? title;
  final String? imageUrl;
  final FaqType? type;
  final List<FaqDetailModel>? faqDetails;

  const FaqModel({
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

final mockFaqs = [
  mockFaqQuestionAnswers,
  mockFaqTutorial,
  mockFaqQuestionAnswers,
  mockFaqTutorial,
];

const mockFaqQuestionAnswers = FaqModel(
  title: "After Care",
  type: FaqType.questionAnswer,
  faqDetails: [
    mockFaqDetail,
    mockFaqDetail,
    mockFaqDetail,
  ],
);

const mockFaqTutorial = FaqModel(
  title: "Tindakan Preventif Usai Injeksi LAMS",
  type: FaqType.tutorials,
  faqDetails: [
    mockFaqDetail,
    mockFaqDetail,
    mockFaqDetail,
  ],
);

const mockFaqDetail = FaqDetailModel(
  title: "Kenapa ukuran dan bentuk badan tetap sama?",
  description:
      "Karena baru beberapa minggu pasca-perawatan, kemajuan mungkin tak terlihat signifikan. \nBahkan setelah sebulan, ada yang belum melihat perubahan. \n\nPerlu diingat, pembengkakan dan memar pada tahap ini dapat mempengaruhi penilaian. \n\nHasil terbaik LAMS seringkali terlihat di bulan ketiga.",
);
