import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  ShimmerLoading.rectangular({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 4,
  }) : shapeBorder = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        );

  const ShimmerLoading.circular({
    super.key,
    this.width,
    this.height,
    this.shapeBorder = const CircleBorder(),
  }) : borderRadius = 99;

  final double? width, height;
  final double borderRadius;
  final ShapeBorder shapeBorder;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFEBEBF4),
      highlightColor: const Color(0xFFF4F4F4),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          shape: shapeBorder,
          color: const Color(0xFFEBEBF4),
        ),
      ),
    );
  }
}
