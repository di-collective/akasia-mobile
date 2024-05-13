part of 'bottom_navigation_cubit.dart';

class BottomNavigationState extends Equatable {
  final BottomNavigationItem selectedItem;

  const BottomNavigationState({
    required this.selectedItem,
  });

  @override
  List<Object> get props => [
        selectedItem,
      ];
}
