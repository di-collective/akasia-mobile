import '../entities/faq_entity.dart';

abstract class FaqRepository {
  Future<List<FaqEntity>> getFaqs();
}
