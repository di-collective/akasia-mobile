import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_treatment_state.freezed.dart';

@freezed
abstract class MyTreatmentState with _$MyTreatmentState {
  const factory MyTreatmentState.initial() = _Initial;

  const factory MyTreatmentState.loaded() = _Loaded;
}
