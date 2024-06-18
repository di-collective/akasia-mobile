import 'package:flutter_bloc/flutter_bloc.dart';

import 'nav_bar_state.dart';

class NavBarCubit extends Cubit<NavBarState> {
  NavBarCubit() : super(const NavBarState());

  void onUpdateSelectedItem(NavBarItem item) {
    emit(state.copy(selectedItem: item));
  }
}
