import '../../../../core/utils/logger.dart';
import '../models/faq_model.dart';
import 'faq_config.dart';

abstract class FaqLocalDataSource {
  Future<List<FaqModel>> getFaqs();
}

class FaqLocalDataSourceImpl implements FaqLocalDataSource {
  @override
  Future<List<FaqModel>> getFaqs() {
    try {
      Logger.info("getFaqs");

      final result = FaqConfig.allFaqs.map((faq) {
        return FaqModel.fromJson(faq);
      }).toList();
      Logger.success("getFaqs result: $result");

      return Future.value(result);
    } catch (error) {
      Logger.error("getFaqs error: $error");

      rethrow;
    }
  }
}
