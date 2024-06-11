import '../../domain/entities/faq_entity.dart';
import '../../domain/repositories/faq_repository.dart';
import '../datasources/faq_local_datasource.dart';

class FaqRepositoryImpl implements FaqRepository {
  final FaqLocalDataSource faqLocalDataSource;

  FaqRepositoryImpl({
    required this.faqLocalDataSource,
  });

  @override
  Future<List<FaqEntity>> getFaqs() async {
    try {
      final result = await faqLocalDataSource.getFaqs();
      return result;
    } catch (_) {
      rethrow;
    }
  }
}
