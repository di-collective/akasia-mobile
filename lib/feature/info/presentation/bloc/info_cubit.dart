import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'info_state.dart';

@lazySingleton
class InfoCubit extends Cubit<InfoState> {
  InfoCubit() : super(const InfoState.initial());

  void onInit() async {
    await Future.delayed(const Duration(seconds: 2));
    emit(const InfoState.loaded());
  }
}
