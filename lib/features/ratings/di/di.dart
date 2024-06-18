import '../../../../core/utils/service_locator.dart';
import '../data/repositories/ratings_repository_impl.dart';
import '../domain/repositories/ratings_repository.dart';
import '../domain/usecases/get_my_reviews_usecase.dart';
import '../domain/usecases/get_recent_reviews_usecase.dart';
import '../presentation/cubit/my_review/my_review_cubit.dart';
import '../presentation/cubit/nav_bar/nav_bar_cubit.dart';
import '../presentation/cubit/recently_reviewed/recently_reviewed_cubit.dart';

final class FutureRatingsDependencies {
  FutureRatingsDependencies._();

  static Future<void> inject() async {
    sl.registerLazySingleton<RatingsRepository>(() => RatingsRepositoryImpl());
    sl.registerLazySingleton(() {
      return GetMyReviewsUseCase(
        ratingsRepository: sl<RatingsRepository>(),
      );
    });
    sl.registerLazySingleton(() {
      return GetRecentReviewsUseCase(
        ratingsRepository: sl<RatingsRepository>(),
      );
    });
    sl.registerFactory<NavBarCubit>(() => NavBarCubit());
    sl.registerFactory<MyReviewCubit>(() {
      return MyReviewCubit(
        getMyReviewsUseCase: sl<GetMyReviewsUseCase>(),
      );
    });
    sl.registerFactory<RecentlyReviewedCubit>(() {
      return RecentlyReviewedCubit(
        getRecentReviewsUseCase: sl<GetRecentReviewsUseCase>(),
      );
    });
  }
}
