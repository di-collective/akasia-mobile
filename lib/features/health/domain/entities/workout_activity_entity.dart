import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../../../core/config/hive_type_id_config.dart';
import '../../../../core/utils/logger.dart';

class WorkoutActivityEntity extends Equatable {
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? type;

  const WorkoutActivityEntity({
    this.fromDate,
    this.toDate,
    this.type,
  });

  @override
  List<Object?> get props => [
        fromDate,
        toDate,
        type,
      ];
}

class WorkoutActivityEntityAdapter extends TypeAdapter<WorkoutActivityEntity> {
  @override
  final int typeId = HiveTypeIdConfig.workoutActivity;

  @override
  WorkoutActivityEntity read(BinaryReader reader) {
    try {
      return WorkoutActivityEntity(
        fromDate: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
        toDate: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
        type: reader.readString(),
      );
    } catch (error) {
      Logger.error('WorkoutActivityEntityAdapter error: $error');

      rethrow;
    }
  }

  @override
  void write(BinaryWriter writer, WorkoutActivityEntity obj) {
    writer.writeInt(obj.fromDate?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(obj.toDate?.millisecondsSinceEpoch ?? 0);
    writer.writeString(obj.type ?? '');
  }
}
