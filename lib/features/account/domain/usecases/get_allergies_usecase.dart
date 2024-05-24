import '../../../../core/usecases/usecase.dart';
import '../../data/models/allergy_model.dart';
import '../repositories/allergy_repository.dart';

class GetAllergiesUseCase extends UseCase<List<AllergyModel>, NoParams> {
  final AllergyRepository allergyRepository;

  GetAllergiesUseCase({
    required this.allergyRepository,
  });

  @override
  Future<List<AllergyModel>> call(NoParams params) async {
    return await allergyRepository.getAllergies();
  }
}
