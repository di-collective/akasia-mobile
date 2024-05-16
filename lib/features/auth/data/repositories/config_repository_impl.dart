import '../../domain/repositories/config_repository.dart';
import '../datasources/local/config_local_datasource.dart';
import '../models/yaml_model.dart';

class ConfigRepositoryImpl implements ConfigRepository {
  final ConfigLocalDataSource configLocalDataSource;

  const ConfigRepositoryImpl({
    required this.configLocalDataSource,
  });

  @override
  Future<YamlModel> getYaml() async {
    try {
      final result = await configLocalDataSource.getYaml();

      return result;
    } catch (_) {
      rethrow;
    }
  }
}
