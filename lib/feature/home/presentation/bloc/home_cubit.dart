import 'home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void onInit() async {
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(isInitializing: false));
  }

  void onLoadSomething() async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(isLoading: false));
  }
}
