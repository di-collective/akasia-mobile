import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/navigation/app_route.dart';
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
        title: Text(context.locale.profile),
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
              height: 40,
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
                  onTap: _onEditAllergies,
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
              padding: const EdgeInsets.all(16),
              width: context.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colorScheme.white,
              ),
              child: Wrap(
                runSpacing: 16,
                spacing: 16,
                children: List.generate(
                  10,
                  (index) => Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: colorScheme.surfaceBright,
                    ),
                    child: Text(
                      'Obat A',
                      style: textTheme.labelLarge.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.locale.emergencyContact,
                  style: textTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceDim,
                  ),
                ),
                GestureDetector(
                  onTap: _onEmergencyContact,
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
                    label: context.locale.relationship,
                    value: 'Wife',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.fullName,
                    value: 'Taylor Swift',
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.outlineBright,
                    thickness: 0.5,
                  ),
                  ProfileDetailItemWidget(
                    label: context.locale.phoneNumber,
                    value: '+62 821 6767 8989',
                  ),
                ],
              ),
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
    // go to edit information page
    context.goNamed(AppRoute.editInformation.name);
  }

  void _onEditAllergies() {
    // TODO: go to edit allergies page
  }

  void _onEmergencyContact() {
    // TODO: go to edit emergency contact page
  }
}
