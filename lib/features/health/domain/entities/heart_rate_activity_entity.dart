import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../../../core/config/hive_type_id_config.dart';
import '../../../../core/utils/logger.dart';

class HeartRateActivityEntity extends Equatable {
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? value;

  const HeartRateActivityEntity({
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

class HeartRateActivityEntityAdapter
    extends TypeAdapter<HeartRateActivityEntity> {
  @override
  final int typeId = HiveTypeIdConfig.heartRateActivity;

  @override
  HeartRateActivityEntity read(BinaryReader reader) {
    try {
      return HeartRateActivityEntity(
        fromDate: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
        toDate: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
        value: reader.readInt(),
      );
    } catch (error) {
      Logger.error('HeartRateActivityEntityAdapter error: $error');

      rethrow;
    }
  }

  @override
  void write(BinaryWriter writer, HeartRateActivityEntity obj) {
    writer.writeInt(obj.fromDate?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(obj.toDate?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(obj.value ?? 0);
  }
}
