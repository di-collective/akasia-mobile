import '../../../../core/utils/service_locator.dart';
import '../cubit/nav_bar/nav_bar_cubit.dart';

Future<void> futureRatingsInject() async {
  sl.registerFactory<NavBarCubit>(() => NavBarCubit());
}
