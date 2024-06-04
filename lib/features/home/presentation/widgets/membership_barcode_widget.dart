import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/dialogs/dialog_widget.dart';
import '../../../../core/ui/widget/loadings/shimmer_loading.dart';
import '../../../account/presentation/cubit/profile/profile_cubit.dart';

class MembershipBarcodeWidget extends StatefulWidget {
  const MembershipBarcodeWidget({super.key});

  @override
  State<MembershipBarcodeWidget> createState() =>
      _MembershipBarcodeWidgetState();
}

class _MembershipBarcodeWidgetState extends State<MembershipBarcodeWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded && state.profile.medicalId != null) {
          return GestureDetector(
            onTap: () => _onShowBrightnessBarcode(
              medicalId: state.profile.medicalId!,
            ),
            child: _ContainerWidget(
              child: Column(
                children: [
                  BarcodeWidget(
                    barcode: Barcode.code128(),
                    data: state.profile.medicalId!,
                    height: 80,
                    width: context.width,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AssetIconsPath.icSun,
                        height: 20,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        context.locale.brightness,
                        style: textTheme.labelMedium.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }

        return _ContainerWidget(
          child: Column(
            children: [
              ShimmerLoading.circular(
                width: context.width,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                height: 80,
              ),
              const SizedBox(
                height: 12,
              ),
              ShimmerLoading.circular(
                width: context.width,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onShowBrightnessBarcode({
    required String medicalId,
  }) async {
    // get current brightness
    final lastBrightness = await ScreenBrightness().system;

    await ScreenBrightness().setAutoReset(true);

    // set brightness to maximum
    await ScreenBrightness().setScreenBrightness(1);

    // show dialog with barcode
    await showDialog(
      context: context,
      builder: (context) {
        final colorScheme = context.theme.appColorScheme;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DialogWidget(
              title: context.locale.membership,
              button: BarcodeWidget(
                barcode: Barcode.code128(),
                data: medicalId,
                height: 90,
                width: 300,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              backgroundColor: Colors.white,
              elevation: 0,
              shape: const CircleBorder(),
              child: Icon(
                Icons.close,
                color: colorScheme.primary,
              ),
            )
          ],
        );
      },
    );

    // reset brightness to last value
    await ScreenBrightness().setScreenBrightness(lastBrightness);
  }
}

class _ContainerWidget extends StatelessWidget {
  final Widget child;

  const _ContainerWidget({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 14,
      ),
      width: context.width,
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.outlineBright,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
