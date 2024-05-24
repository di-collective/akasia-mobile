import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../data/models/allergy_model.dart';
import '../../../domain/usecases/get_allergies_usecase.dart';

part 'get_allergies_state.dart';

class GetAllergiesCubit extends Cubit<GetAllergiesState> {
  final GetAllergiesUseCase getAllergiesUseCase;

  GetAllergiesCubit({
    required this.getAllergiesUseCase,
  }) : super(GetAllergiesInitial());

  Future<void> getAllergies() async {
    try {
      emit(GetAllergiesLoading());

      final allergies = await getAllergiesUseCase.call(NoParams());

      emit(GetAllergiesLoaded(allergies: allergies));
    } catch (error) {
      emit(GetAllergiesError(error: error));

      rethrow;
    }
  }
}
