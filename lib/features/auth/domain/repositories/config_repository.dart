import '../../data/models/yaml_model.dart';

abstract class ConfigRepository {
  Future<YamlModel> getYaml();
}
