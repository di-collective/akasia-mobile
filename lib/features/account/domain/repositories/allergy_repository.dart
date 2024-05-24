import '../../data/models/allergy_model.dart';

abstract class AllergyRepository {
  Future<List<AllergyModel>> getAllergies();
}
