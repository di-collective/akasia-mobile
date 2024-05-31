import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../data/models/profile_model.dart';
import '../../../domain/usecases/get_profile_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
  }) : super(ProfileInitial());

  void init() {
    emit(ProfileInitial());
  }

  Future<void> getProfile() async {
    try {
      // validate current state
      if (state is ProfileLoading) return;

      emit(ProfileLoading());

      final profile = await getProfileUseCase.call(NoParams());

      emit(ProfileLoaded(profile: profile));
    } catch (error) {
      emit(ProfileError(error: error));

      rethrow;
    }
  }
}
