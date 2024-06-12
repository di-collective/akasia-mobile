import 'package:equatable/equatable.dart';

class FaqDetailEntity extends Equatable {
  final String? title;
  final String? description;
  final List<String?>? items;

  const FaqDetailEntity({
    this.title,
    this.description,
    this.items,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        items,
      ];
}
