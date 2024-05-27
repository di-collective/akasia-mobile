import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../data/models/allergy_model.dart';
import '../../../domain/usecases/get_allergies_usecase.dart';

part 'allergies_state.dart';

class AllergiesCubit extends Cubit<AllergiesState> {
  final GetAllergiesUseCase getAllergiesUseCase;

  AllergiesCubit({
    required this.getAllergiesUseCase,
  }) : super(AllergiesInitial());

  Future<void> getAllergies() async {
    try {
      emit(AllergiesLoading());

      final allergies = await getAllergiesUseCase.call(NoParams());

      emit(AllergiesLoaded(allergies: allergies));
    } catch (error) {
      emit(AllergiesError(error: error));

      rethrow;
    }
  }

  void updateAllergies(List<AllergyModel> allergies) {
    emit(AllergiesLoaded(allergies: allergies));
  }
}
