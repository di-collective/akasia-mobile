import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class NavBarState extends Equatable {
  final NavBarItem selectedItem;

  const NavBarState({
    this.selectedItem = NavBarItem.recentlyReviewed,
  });

  @override
  List<Object?> get props => [selectedItem];

  NavBarState copy({
    NavBarItem? selectedItem,
  }) {
    return NavBarState(selectedItem: selectedItem ?? this.selectedItem);
  }
}

enum NavBarItem {
  recentlyReviewed,
  myReview;
}
