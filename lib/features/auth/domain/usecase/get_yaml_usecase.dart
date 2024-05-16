import '../../../../core/usecases/usecase.dart';
import '../../data/models/yaml_model.dart';
import '../repositories/config_repository.dart';

class GetYamlUseCase extends UseCase<YamlModel, NoParams> {
  final ConfigRepository configRepository;

  GetYamlUseCase({
    required this.configRepository,
  });

  @override
  Future<YamlModel> call(NoParams params) async {
    return await configRepository.getYaml();
  }
}
