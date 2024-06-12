import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String? id;
  final String? title;
  final String? description;
  final String? date;

  const NotificationEntity({
    this.id,
    this.title,
    this.description,
    this.date,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        date,
      ];
}
