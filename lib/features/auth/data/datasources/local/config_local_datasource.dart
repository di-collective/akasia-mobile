import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

import '../../../../../core/utils/logger.dart';
import '../../models/yaml_model.dart';

abstract class ConfigLocalDataSource {
  Future<YamlModel> getYaml();
}

class ConfigLocalDataSourceImpl implements ConfigLocalDataSource {
  @override
  Future<YamlModel> getYaml() async {
    try {
      Logger.info('getYaml');

      final data = await rootBundle.loadString("pubspec.yaml");
      final yamlData = loadYaml(data);
      Logger.success('getYaml result: $yamlData');

      return YamlModel.fromJson(yamlData);
    } catch (error) {
      Logger.error('getYaml error: $error');

      rethrow;
    }
  }
}
