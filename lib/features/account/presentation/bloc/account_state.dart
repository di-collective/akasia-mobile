import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_state.freezed.dart';

@freezed
abstract class AccountState with _$AccountState {
  const factory AccountState.initial() = _Initial;

  const factory AccountState.loaded() = _Loaded;
}
