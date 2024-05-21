import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';
import '../widgets/profile_detail_item_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      backgroundColor: colorScheme.surfaceBright,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.paddingHorizontal,
        ),
        child: Column(
          children: [
            SizedBox(
              height: context.paddingTop,
            ),
            const NetworkImageWidget(
              size: Size(120, 120),
              shape: BoxShape.circle,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 24,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.locale.information,
                  style: textTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceDim,
                  ),
                ),
                GestureDetector(
                  onTap: _onEditInformation,
                  child: Text(
                    context.locale.edit,
                    style: textTheme.labelLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colorScheme.white,
              ),
              child: Column(
                children: [
                  ProfileDetailItemWidget(
                    label: context.locale.membershipId,
                    value: 'MP-12345678',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.eKtpNumber,
                    value: '35743212809076543',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.fullName,
                    value: 'John Doe',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.phoneNumber,
                    value: 'Phone Number',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.age,
                    value: '34 yo',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.dob,
                    value: '11-01-1990',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.sex,
                    value: 'Male',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.bloodType,
                    value: 'B',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.weight,
                    value: '52 kgs',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.height,
                    value: '170 cm',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.activityLevel,
                    value: 'Sedentary',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.locale.allergies,
                  style: textTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceDim,
                  ),
                ),
                GestureDetector(
                  onTap: _onEditInformation,
                  child: Text(
                    context.locale.edit,
                    style: textTheme.labelLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: context.paddingBottom,
            ),
          ],
        ),
      ),
    );
  }

  void _onEditInformation() {
    // TODO: go to edit information page
  }
}
