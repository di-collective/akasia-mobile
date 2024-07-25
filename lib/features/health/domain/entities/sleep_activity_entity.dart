import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../../../core/config/hive_type_id_config.dart';
import 'activity_entity.dart';

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

class SleepActivityEntityAdapter
    extends TypeAdapter<ActivityEntity<List<SleepActivityEntity>>> {
  @override
  final int typeId = HiveTypeIdConfig.sleepActivity;

  @override
  ActivityEntity<List<SleepActivityEntity>> read(BinaryReader reader) {
    final createdAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final updatedAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final dataLength = reader.readInt();
    final data = <SleepActivityEntity>[];

    for (var i = 0; i < dataLength; i++) {
      data.add(SleepActivityEntity(
        fromDate: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
        toDate: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      ));
    }

    return ActivityEntity<List<SleepActivityEntity>>(
      createdAt: createdAt,
      updatedAt: updatedAt,
      data: data,
    );
  }

  @override
  void write(
      BinaryWriter writer, ActivityEntity<List<SleepActivityEntity>> obj) {
    writer.writeInt(obj.createdAt?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(obj.updatedAt?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(obj.data?.length ?? 0);

    obj.data?.forEach((activity) {
      writer.writeInt(activity.fromDate?.millisecondsSinceEpoch ?? 0);
      writer.writeInt(activity.toDate?.millisecondsSinceEpoch ?? 0);
    });
  }
}