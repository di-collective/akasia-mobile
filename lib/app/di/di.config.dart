// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i9;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../core/network/http/app_http_client.dart' as _i10;
import '../../core/network/http/auth_interceptor.dart' as _i11;
import '../../core/network/http/logging_interceptor.dart' as _i3;
import '../../core/network/network_register_module.dart' as _i16;
import '../../feature/account/presentation/bloc/account_cubit.dart' as _i8;
import '../../feature/auth/data/repository/auth_repository_impl.dart' as _i14;
import '../../feature/auth/data/source/local/auth_local_data_source.dart'
    as _i4;
import '../../feature/auth/data/source/remote/auth_remote_data_source.dart'
    as _i12;
import '../../feature/auth/domain/repository/auth_repository.dart' as _i13;
import '../../feature/auth/domain/usecase/login_usecase.dart' as _i15;
import '../../feature/home/presentation/bloc/home_cubit.dart' as _i5;
import '../../feature/info/presentation/bloc/info_cubit.dart' as _i7;
import '../../feature/my_treatment/presentation/bloc/my_treatment_cubit.dart'
    as _i6;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final networkRegisterModule = _$NetworkRegisterModule();
    gh.lazySingleton<_i3.LoggingInterceptor>(() => _i3.LoggingInterceptor());
    gh.lazySingleton<_i4.AuthLocalDataSource>(() => _i4.AuthLocalDataSource());
    gh.lazySingleton<_i5.HomeCubit>(() => _i5.HomeCubit());
    gh.lazySingleton<_i6.MyTreatmentCubit>(() => _i6.MyTreatmentCubit());
    gh.lazySingleton<_i7.InfoCubit>(() => _i7.InfoCubit());
    gh.lazySingleton<_i8.AccountCubit>(() => _i8.AccountCubit());
    gh.lazySingleton<_i9.Dio>(
        () => networkRegisterModule.dio(gh<_i3.LoggingInterceptor>()));
    gh.lazySingleton<_i10.AppHttpClient>(
        () => _i10.AppHttpClient(gh<_i9.Dio>()));
    gh.lazySingleton<_i11.AuthInterceptor>(
        () => _i11.AuthInterceptor(gh<_i9.Dio>()));
    gh.lazySingleton<_i12.AuthRemoteDataSource>(
        () => _i12.AuthRemoteDataSource(gh<_i10.AppHttpClient>()));
    gh.lazySingleton<_i13.AuthRepository>(() => _i14.AuthRepositoryImpl(
          gh<_i4.AuthLocalDataSource>(),
          gh<_i12.AuthRemoteDataSource>(),
        ));
    gh.lazySingleton<_i15.LoginUseCase>(
        () => _i15.LoginUseCase(gh<_i13.AuthRepository>()));
    return this;
  }
}

class _$NetworkRegisterModule extends _i16.NetworkRegisterModule {}
