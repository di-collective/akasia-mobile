import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/extensions/bottom_navigation_item_parsing.dart';

part 'bottom_navigation_state.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  BottomNavigationCubit()
      : super(
          const BottomNavigationState(
            selectedItem: BottomNavigationItem.home,
          ),
        );

  void init() {
    emit(const BottomNavigationState(
      selectedItem: BottomNavigationItem.home,
    ));
  }

  void onChanged(BottomNavigationItem item) {
    emit(BottomNavigationState(
      selectedItem: item,
    ));
  }
}
