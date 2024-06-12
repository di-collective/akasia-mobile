import '../../../../core/usecases/usecase.dart';
import '../entities/faq_entity.dart';
import '../repositories/faq_repository.dart';

class GetFaqsUseCase extends UseCase<List<FaqEntity>, NoParams> {
  final FaqRepository faqRepository;

  GetFaqsUseCase({
    required this.faqRepository,
  });

  @override
  Future<List<FaqEntity>> call(NoParams params) async {
    return await faqRepository.getFaqs();
  }
}
