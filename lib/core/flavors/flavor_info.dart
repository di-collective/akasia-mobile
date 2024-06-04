import 'package:flutter_flavor/flutter_flavor.dart';

import 'flavor_name_key.dart';
import 'flavor_type_extension.dart';

abstract class FlavorInfo {
  FlavorType get type;
}

class FlavorInfoImpl implements FlavorInfo {
  @override
  FlavorType get type {
    return FlavorConfig.instance.variables[FlavorNameKey.type];
  }
}
