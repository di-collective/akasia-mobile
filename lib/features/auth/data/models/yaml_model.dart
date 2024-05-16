import 'package:yaml/yaml.dart';

import '../../domain/entities/yaml_entity.dart';

class YamlModel extends YamlEntity {
  const YamlModel({
    super.version,
    super.buildNumber,
  });

  factory YamlModel.fromJson(YamlMap yaml) {
    return YamlModel(
      version: getAppVersion(appVersion: yaml['version']),
      buildNumber: getAppBuildNumber(appVersion: yaml['version']),
    );
  }

  static String? getAppVersion({
    required String? appVersion,
  }) {
    // version should be in format x.x.x+x
    final datas = appVersion?.split('+');
    return datas?.first;
  }

  static String? getAppBuildNumber({
    required String? appVersion,
  }) {
    // version should be in format x.x.x+x
    final datas = appVersion?.split('+');
    return datas?.last;
  }

  Map<String, dynamic> toMap() {
    return {
      'version': version,
      'buildNumber': buildNumber,
    };
  }
}
