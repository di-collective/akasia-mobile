import '../../domain/entities/yaml_entity.dart';
import '../../domain/repositories/config_repository.dart';
import '../datasources/local/config_local_datasource.dart';

class ConfigRepositoryImpl implements ConfigRepository {
  final ConfigLocalDataSource configLocalDataSource;

  const ConfigRepositoryImpl({
    required this.configLocalDataSource,
  });

  @override
  Future<YamlEntity> getYaml() async {
    try {
      final result = await configLocalDataSource.getYaml();

      return result;
    } catch (_) {
      rethrow;
    }
  }
}
