import '../entities/yaml_entity.dart';

abstract class ConfigRepository {
  Future<YamlEntity> getYaml();
}
