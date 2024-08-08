import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../../../core/config/hive_type_id_config.dart';
import '../../../../core/utils/logger.dart';

class StepsActivityEntity extends Equatable {
  final DateTime? date;
  final int? count;

  const StepsActivityEntity({
    this.date,
    this.count,
  });

  @override
  List<Object?> get props => [date, count];
}

class StepsActivityEntityAdapter extends TypeAdapter<StepsActivityEntity> {
  @override
  final int typeId = HiveTypeIdConfig.stepsActivity;

  @override
  StepsActivityEntity read(BinaryReader reader) {
    try {
      return StepsActivityEntity(
        date: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
        count: reader.readInt(),
      );
    } catch (error) {
      Logger.error('StepsActivityEntityAdapter error: $error');

      rethrow;
    }
  }

  @override
  void write(BinaryWriter writer, StepsActivityEntity obj) {
    writer.writeInt(obj.date?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(obj.count ?? 0);
  }
}
