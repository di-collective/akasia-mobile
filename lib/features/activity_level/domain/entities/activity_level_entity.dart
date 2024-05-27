import 'package:equatable/equatable.dart';

class ActivityLevelEntity extends Equatable {
  final String? id;
  final String? activity;
  final String? description;

  const ActivityLevelEntity({
    this.id,
    this.activity,
    this.description,
  });

  @override
  List<Object?> get props => [id, activity, description];
}
