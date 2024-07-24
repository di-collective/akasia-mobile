import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../../../core/config/hive_type_id_config.dart';
import 'activity_entity.dart';

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
    extends TypeAdapter<ActivityEntity<List<HeartRateActivityEntity>>> {
  @override
  final int typeId = HiveTypeIdConfig.heartRateActivity;

  @override
  ActivityEntity<List<HeartRateActivityEntity>> read(BinaryReader reader) {
    final createdAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final updatedAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final dataLength = reader.readInt();
    final data = <HeartRateActivityEntity>[];

    for (var i = 0; i < dataLength; i++) {
      data.add(HeartRateActivityEntity(
        fromDate: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
        toDate: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
        value: reader.readInt(),
      ));
    }

    return ActivityEntity<List<HeartRateActivityEntity>>(
      createdAt: createdAt,
      updatedAt: updatedAt,
      data: data,
    );
  }

  @override
  void write(
      BinaryWriter writer, ActivityEntity<List<HeartRateActivityEntity>> obj) {
    writer.writeInt(obj.createdAt?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(obj.updatedAt?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(obj.data?.length ?? 0);

    obj.data?.forEach((activity) {
      writer.writeInt(activity.fromDate?.millisecondsSinceEpoch ?? 0);
      writer.writeInt(activity.toDate?.millisecondsSinceEpoch ?? 0);
      writer.writeInt(activity.value ?? 0);
    });
  }
}
