import '../../../../core/usecases/usecase.dart';
import '../entities/yaml_entity.dart';
import '../repositories/config_repository.dart';

class GetYamlUseCase extends UseCase<YamlEntity, NoParams> {
  final ConfigRepository configRepository;

  GetYamlUseCase({
    required this.configRepository,
  });

  @override
  Future<YamlEntity> call(NoParams params) async {
    return await configRepository.getYaml();
  }
}
