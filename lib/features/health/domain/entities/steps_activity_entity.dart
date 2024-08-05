import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../../../core/config/hive_type_id_config.dart';
import 'activity_entity.dart';

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

class StepsActivityEntityAdapter
    extends TypeAdapter<ActivityEntity<List<StepsActivityEntity>>> {
  @override
  final int typeId = HiveTypeIdConfig.stepsActivity;

  @override
  ActivityEntity<List<StepsActivityEntity>> read(BinaryReader reader) {
    final createdAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final updatedAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final dataLength = reader.readInt();
    final data = <StepsActivityEntity>[];

    for (var i = 0; i < dataLength; i++) {
      data.add(StepsActivityEntity(
        date: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
        count: reader.readInt(),
      ));
    }

    return ActivityEntity<List<StepsActivityEntity>>(
      createdAt: createdAt,
      updatedAt: updatedAt,
      data: data,
    );
  }

  @override
  void write(
      BinaryWriter writer, ActivityEntity<List<StepsActivityEntity>> obj) {
    writer.writeInt(obj.createdAt?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(obj.updatedAt?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(obj.data?.length ?? 0);

    obj.data?.forEach((activity) {
      writer.writeInt(activity.date?.millisecondsSinceEpoch ?? 0);
      writer.writeInt(activity.count ?? 0);
    });
  }
}
