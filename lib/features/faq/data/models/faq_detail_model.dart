import 'package:equatable/equatable.dart';

class FaqDetailModel extends Equatable {
  final String? title;
  final String? description;

  const FaqDetailModel({
    this.title,
    this.description,
  });

  @override
  List<Object?> get props => [
        title,
        description,
      ];
}
