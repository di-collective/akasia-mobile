import 'package:equatable/equatable.dart';

class YamlEntity extends Equatable {
  final String? version;
  final String? buildNumber;

  const YamlEntity({
    this.version,
    this.buildNumber,
  });

  @override
  List<Object?> get props => [
        version,
        buildNumber,
      ];
}
