import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../../../core/config/hive_type_id_config.dart';
import 'activity_entity.dart';

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

class WorkoutActivityEntityAdapter
    extends TypeAdapter<ActivityEntity<List<WorkoutActivityEntity>>> {
  @override
  final int typeId = HiveTypeIdConfig.workoutActivity;

  @override
  ActivityEntity<List<WorkoutActivityEntity>> read(BinaryReader reader) {
    final createdAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final updatedAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final dataLength = reader.readInt();
    final data = <WorkoutActivityEntity>[];

    for (var i = 0; i < dataLength; i++) {
      data.add(WorkoutActivityEntity(
        fromDate: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
        toDate: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
        type: reader.readString(),
      ));
    }

    return ActivityEntity<List<WorkoutActivityEntity>>(
      createdAt: createdAt,
      updatedAt: updatedAt,
      data: data,
    );
  }

  @override
  void write(
      BinaryWriter writer, ActivityEntity<List<WorkoutActivityEntity>> obj) {
    writer.writeInt(obj.createdAt?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(obj.updatedAt?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(obj.data?.length ?? 0);

    obj.data?.forEach((activity) {
      writer.writeInt(activity.fromDate?.millisecondsSinceEpoch ?? 0);
      writer.writeInt(activity.toDate?.millisecondsSinceEpoch ?? 0);
      writer.writeString(activity.type ?? '');
    });
  }
}
