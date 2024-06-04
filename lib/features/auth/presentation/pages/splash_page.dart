import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/deep_link_info.dart';
import '../../../../core/config/asset_path.dart';
import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/toast_type_extension.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../account/presentation/cubit/profile/profile_cubit.dart';
import '../../domain/usecase/get_access_token_usecase.dart';
import '../cubit/yaml/yaml_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {
    try {
      // init deep links
      sl<DeepLinkInfo>().init();

      final result = await Future.wait([
        // minimum splash duration
        Future.delayed(const Duration(seconds: 3)),

        // check sign in status
        _isSignIn(),

        // get yaml
        BlocProvider.of<YamlCubit>(context).getYaml(),
      ]);

      // check sign in status
      final bool isSignIn = result[1];

      if (isSignIn) {
        // go to main page
        context.goNamed(AppRoute.main.name);

        return;
      }

      // go to sign in page
      context.goNamed(AppRoute.signIn.name);
    } catch (error) {
      context.showToast(
        type: ToastType.error,
        message: error.message(context),
      );

      // go to sign in page
      context.goNamed(AppRoute.signIn.name);
    }
  }

  Future<bool> _isSignIn() async {
    try {
      // check access token
      final token = await sl<GetAccessTokenUseCase>().call(NoParams());
      if (token == null) {
        return false;
      }

      // get profile
      await BlocProvider.of<ProfileCubit>(context).getProfile();

      return true;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.theme.appColorScheme;

    return Scaffold(
      backgroundColor: color.primary,
      body: SizedBox(
        width: context.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AssetImagesPath.logoTextWhite,
              height: 35,
            ),
            SizedBox(
              height: context.height * 0.3,
            ),
          ],
        ),
      ),
    );
  }
}
