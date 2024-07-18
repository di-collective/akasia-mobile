import '../../app/routes/app_route_info.dart';
import '../common/deep_link_info.dart';
import '../common/directory_info.dart';
import '../common/image_compress_info.dart';
import '../common/local_picker_info.dart';
import '../common/open_app_info.dart';
import '../flavors/flavor_info.dart';
import '../network/http/app_http_client.dart';
import '../network/network_info.dart';
import '../services/health_service.dart';
import '../ui/widget/dialogs/bottom_sheet_info.dart';
import '../ui/widget/dialogs/toast_info.dart';
import '../ui/widget/loadings/cubit/countdown/countdown_cubit.dart';
import '../ui/widget/loadings/cubit/full_screen_loading/full_screen_loading_cubit.dart';
import '../utils/permission_info.dart';
import '../utils/service_locator.dart';

class CoreDI {
  CoreDI._();

  static void inject() {
    // flavor info
    sl.registerLazySingleton<FlavorInfo>(() {
      return FlavorInfoImpl();
    });

    // app route info
    sl.registerLazySingleton<AppRouteInfo>(() {
      return AppRouteInfoImpl(
        flavorInfo: sl(),
      );
    });

    // toast info
    sl.registerLazySingleton<ToastInfo>(() {
      return ToastInfoImpl();
    });

    // network info
    sl.registerLazySingleton<NetworkInfo>(() {
      return NetworkInfoImpl(
        connectivity: sl(),
      );
    });

    // app http client
    sl.registerLazySingleton<AppHttpClient>(() {
      return AppHttpClient(
        dio: sl(),
      );
    });

    // open app info
    sl.registerLazySingleton<OpenAppInfo>(() {
      return const OpenAppInfoImpl();
    });

    // full screen loading cubit
    sl.registerFactory<FullScreenLoadingCubit>(() {
      return FullScreenLoadingCubit();
    });

    // countdown
    sl.registerFactory<CountdownCubit>(() {
      return CountdownCubit();
    });

    // local picker info
    sl.registerLazySingleton<LocalPickerInfo>(() {
      return LocalPickerInfoImpl(
        imagePicker: sl(),
      );
    });

    // directory info
    sl.registerLazySingleton<DirectoryInfo>(() {
      return const DirectoryInfoImpl();
    });

    // image compress info
    sl.registerLazySingleton<ImageCompressInfo>(() {
      return ImageCompressInfoImpl(
        directoryInfo: sl(),
      );
    });

    // bottom sheet info
    sl.registerLazySingleton<BottomSheetInfo>(() {
      return BottomSheetInfoImpl();
    });

    // deep link info
    sl.registerLazySingleton<DeepLinkInfo>(() {
      return DeepLinkInfoImpl(
        appLinks: sl(),
        appRouteInfo: sl(),
      );
    });

    // permission info
    sl.registerLazySingleton<PermissionInfo>(() {
      return PermissionInfoImpl();
    });

    // health service
    sl.registerLazySingleton<HealthService>(() {
      return HealthServiceImpl(
        health: sl(),
        permissionInfo: sl(),
      );
    });
  }
}
