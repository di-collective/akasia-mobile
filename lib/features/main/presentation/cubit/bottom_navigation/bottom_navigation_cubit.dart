import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_navigation_state.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  BottomNavigationCubit()
      : super(
          const BottomNavigationState(
            selectedIndex: 0,
          ),
        );

  void init() {
    emit(const BottomNavigationState(
      selectedIndex: 0,
    ));
  }

  void onChanged(int? index) {
    if (index != null) {
      emit(BottomNavigationState(
        selectedIndex: index,
      ));
    }
  }
}
