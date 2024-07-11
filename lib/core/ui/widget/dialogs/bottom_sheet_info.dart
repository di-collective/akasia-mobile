import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

abstract class BottomSheetInfo {
  Future<T> showCupertinoModal<T>({
    required BuildContext context,
    required Widget child,
  });
  Future<T> showMaterialModal<T>({
    required BuildContext context,
    Color? backgroundColor,
    required Widget Function(BuildContext) builder,
    bool? isDismissible,
    bool? enableDrag,
  });
}

class BottomSheetInfoImpl implements BottomSheetInfo {
  @override
  Future<T> showCupertinoModal<T>({
    required BuildContext context,
    required Widget child,
  }) async {
    return await showCupertinoModalBottomSheet(
      expand: true,
      useRootNavigator: true,
      duration: const Duration(milliseconds: 250),
      context: context,
      isDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      builder: (context) {
        return child;
      },
    );
  }

  @override
  Future<T> showMaterialModal<T>({
    required BuildContext context,
    Color? backgroundColor,
    required Widget Function(BuildContext) builder,
    bool? isDismissible,
    bool? enableDrag,
    double? maxHeight,
  }) async {
    return await showMaterialModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor ?? Colors.white,
      isDismissible: isDismissible ?? true,
      enableDrag: enableDrag ?? true,
      useRootNavigator: true,
      barrierColor: Colors.black.withOpacity(0.5),
      duration: const Duration(milliseconds: 250),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: builder,
    );
  }
}
