part of 'faqs_cubit.dart';

sealed class FaqsState extends Equatable {
  const FaqsState();

  @override
  List<Object?> get props => [];
}

final class FaqsInitial extends FaqsState {}

final class FaqsLoading extends FaqsState {}

final class FaqsLoaded extends FaqsState {
  final List<FaqEntity> faqs;

  const FaqsLoaded({
    required this.faqs,
  });

  @override
  List<Object> get props => [faqs];
}

final class FaqsError extends FaqsState {
  final Object error;

  const FaqsError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
