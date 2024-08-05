import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../../../core/config/hive_type_id_config.dart';
import '../../../../core/utils/logger.dart';

class SleepActivityEntity extends Equatable {
  final DateTime? fromDate;
  final DateTime? toDate;

  const SleepActivityEntity({
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [fromDate, toDate];
}

class SleepActivityEntityAdapter extends TypeAdapter<SleepActivityEntity> {
  @override
  final int typeId = HiveTypeIdConfig.sleepActivity;

  @override
  SleepActivityEntity read(BinaryReader reader) {
    try {
      return SleepActivityEntity(
        fromDate: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
        toDate: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      );
    } catch (error) {
      Logger.error('SleepActivityEntityAdapter error: $error');

      rethrow;
    }
  }

  @override
  void write(BinaryWriter writer, SleepActivityEntity obj) {
    writer.writeInt(obj.fromDate?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(obj.toDate?.millisecondsSinceEpoch ?? 0);
  }
}
