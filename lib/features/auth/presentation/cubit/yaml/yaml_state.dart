part of 'yaml_cubit.dart';

sealed class YamlState extends Equatable {
  const YamlState();

  @override
  List<Object?> get props => [];
}

final class YamlInitial extends YamlState {}

final class YamlLoading extends YamlState {}

final class YamlLoaded extends YamlState {
  final YamlModel yaml;

  const YamlLoaded({
    required this.yaml,
  });

  @override
  List<Object?> get props => [yaml];
}

final class YamlError extends YamlState {
  final Object error;

  const YamlError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
