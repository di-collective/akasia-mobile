import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'my_treatment_state.dart';

@lazySingleton
class MyTreatmentCubit extends Cubit<MyTreatmentState> {
  MyTreatmentCubit() : super(const MyTreatmentState.initial());

  void onInit() async {
    await Future.delayed(const Duration(seconds: 2));
    emit(const MyTreatmentState.loaded());
  }
}
