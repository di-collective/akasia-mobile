import 'package:freezed_annotation/freezed_annotation.dart';

part 'info_state.freezed.dart';

@freezed
abstract class InfoState with _$InfoState {
  const factory InfoState.initial() = _Initial;

  const factory InfoState.loaded() = _Loaded;
}
