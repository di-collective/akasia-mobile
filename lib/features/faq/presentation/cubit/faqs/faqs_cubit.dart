import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/faq_entity.dart';
import '../../../domain/usecases/get_faqs_usecase.dart';

part 'faqs_state.dart';

class FaqsCubit extends Cubit<FaqsState> {
  final GetFaqsUseCase getFaqsUseCase;

  FaqsCubit({
    required this.getFaqsUseCase,
  }) : super(FaqsInitial());

  Future<void> getFaqs() async {
    try {
      emit(FaqsLoading());

      final faqs = await getFaqsUseCase(NoParams());
      emit(FaqsLoaded(faqs: faqs));
    } catch (error) {
      emit(FaqsError(error: error));
    }
  }
}
