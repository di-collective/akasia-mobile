import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/yaml_entity.dart';
import '../../../domain/usecase/get_yaml_usecase.dart';

part 'yaml_state.dart';

class YamlCubit extends Cubit<YamlState> {
  final GetYamlUseCase getYamlUseCase;

  YamlCubit({
    required this.getYamlUseCase,
  }) : super(YamlInitial());

  Future<YamlEntity> getYaml() async {
    emit(YamlLoading());

    try {
      final yaml = await getYamlUseCase(NoParams());
      emit(YamlLoaded(yaml: yaml));

      return yaml;
    } catch (error) {
      emit(YamlError(error: error));

      rethrow;
    }
  }
}
