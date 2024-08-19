import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../../domain/usecases/get_profile_usecase.dart';
import '../../../domain/usecases/update_profile_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UpdateProfileUseCase updateProfileUseCase;
  final GetProfileUseCase getProfileUseCase;

  ProfileCubit({
    required this.updateProfileUseCase,
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

  void emitProfileData(ProfileEntity profile) {
    emit(ProfileLoaded(profile: profile));
  }

  Future<void> refreshGetProfile() async {
    try {
      final profile = await getProfileUseCase.call(NoParams());

      emit(ProfileLoaded(profile: profile));
    } catch (_) {
      rethrow;
    }
  }

  Future<ProfileEntity?> updateProfile({
    required ProfileEntity newProfile,
  }) async {
    try {
      ProfileEntity activeProfile = const ProfileEntity();

      final currentState = state;
      if (currentState is ProfileLoading) {
        return null;
      }
      if (currentState is ProfileLoaded) {
        activeProfile = currentState.profile;
      }

      await updateProfileUseCase.call(
        UpdateProfileParams(
          profile: newProfile,
        ),
      );

      activeProfile = activeProfile.copyWith(
        nik: newProfile.nik,
        name: newProfile.name,
        countryCode: newProfile.countryCode,
        phone: newProfile.phone,
        age: newProfile.age,
        dob: newProfile.dob,
        sex: newProfile.sex,
        bloodType: newProfile.bloodType,
        weight: newProfile.weight,
        height: newProfile.height,
        activityLevel: newProfile.activityLevel,
      );

      emit(ProfileLoaded(
        profile: activeProfile,
      ));

      return activeProfile;
    } catch (_) {
      rethrow;
    }
  }
}
