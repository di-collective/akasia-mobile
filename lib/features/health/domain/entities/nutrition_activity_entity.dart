import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../../../core/config/hive_type_id_config.dart';
import '../../../../core/utils/logger.dart';

class NutritionActivityEntity extends Equatable {
  final DateTime? fromDate;
  final DateTime? toDate;
  final double? value;

  const NutritionActivityEntity({
    this.fromDate,
    this.toDate,
    this.value,
  });

  @override
  List<Object?> get props => [
        fromDate,
        toDate,
        value,
      ];
}

class NutritionActivityEntityAdapter
    extends TypeAdapter<NutritionActivityEntity> {
  @override
  final int typeId = HiveTypeIdConfig.nutritionActivity;

  @override
  NutritionActivityEntity read(BinaryReader reader) {
    try {
      return NutritionActivityEntity(
        fromDate: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
        toDate: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
        value: reader.readDouble(),
      );
    } catch (error) {
      Logger.error('NutritionActivityEntityAdapter error: $error');

      rethrow;
    }
  }

  @override
  void write(BinaryWriter writer, NutritionActivityEntity obj) {
    writer.writeInt(obj.fromDate?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(obj.toDate?.millisecondsSinceEpoch ?? 0);
    writer.writeDouble(obj.value ?? 0);
  }
}
