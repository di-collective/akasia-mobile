import 'package:equatable/equatable.dart';

enum DeepLinkAction {
  redirectToPage,
}

class DeepLinkModel extends Equatable {
  final DeepLinkAction? action;
  final Map<String, dynamic> data;

  const DeepLinkModel({
    required this.action,
    required this.data,
  });

  @override
  List<Object?> get props => [action, data];
}
