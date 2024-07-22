import 'package:equatable/equatable.dart';

class ActivityEntity<T> extends Equatable {
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final T? data;

  const ActivityEntity({
    this.createdAt,
    this.updatedAt,
    this.data,
  });

  @override
  List<Object?> get props => [
        createdAt,
        updatedAt,
        data,
      ];
}
