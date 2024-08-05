import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../config/asset_path.dart';
import '../loadings/shimmer_loading.dart';

class NetworkImageWidget extends StatelessWidget {
  final String? imageUrl;
  final Size? size;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final ShapeBorder? shapeBorder;
  final bool? isLoading;
  final Widget? child;
  final double? opcatity;

  const NetworkImageWidget({
    super.key,
    this.imageUrl,
    this.size,
    this.fit,
    this.borderRadius,
    this.shapeBorder,
    this.isLoading,
    this.child,
    this.opcatity,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return ShimmerLoading.circular(
        width: size?.width,
        height: size?.height,
        shapeBorder: shape,
      );
    }

    if (imageUrl == null) {
      return PlaceholderImageWidget(
        size: size,
        fit: fit,
        shapeBorder: shape,
        opcatity: opcatity,
        child: child,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: fit,
      width: size?.width,
      height: size?.height,
      imageBuilder: (context, imageProvider) {
        return Container(
          width: size?.width,
          height: size?.height,
          decoration: ShapeDecoration(
            shape: shape,
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
            ),
          ),
          child: Container(
            decoration: ShapeDecoration(
              color: _opacityColor,
              shape: shape,
            ),
            child: child,
          ),
        );
      },
      placeholder: (context, url) {
        return PlaceholderImageWidget(
          size: size,
          fit: fit,
          shapeBorder: shape,
          opcatity: opcatity,
          child: child,
        );
      },
      errorWidget: (context, url, error) {
        return PlaceholderImageWidget(
          size: size,
          fit: fit,
          shapeBorder: shape,
          opcatity: opcatity,
          child: child,
        );
      },
    );
  }

  ShapeBorder get shape {
    if (shapeBorder != null) {
      return shapeBorder!;
    }

    if (borderRadius != null) {
      return RoundedRectangleBorder(
        borderRadius: borderRadius!,
      );
    }

    return const RoundedRectangleBorder();
  }

  Color? get _opacityColor {
    if (opcatity != null) {
      return Colors.black.withOpacity(opcatity!);
    }

    return null;
  }
}

class PlaceholderImageWidget extends StatelessWidget {
  final Size? size;
  final BoxFit? fit;

  final ShapeBorder shapeBorder;
  final Widget? child;
  final double? opcatity;

  const PlaceholderImageWidget({
    super.key,
    this.size,
    this.fit,
    required this.shapeBorder,
    this.child,
    this.opcatity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size?.width,
      height: size?.height,
      decoration: ShapeDecoration(
        shape: shapeBorder,
        image: DecorationImage(
          image: AssetImage(
            AssetImagesPath.placeholder,
          ),
          fit: fit,
        ),
      ),
      child: Container(
        decoration: ShapeDecoration(
          color: _opacityColor,
          shape: shapeBorder,
        ),
        child: child,
      ),
    );
  }

  Color? get _opacityColor {
    if (opcatity != null) {
      return Colors.black.withOpacity(opcatity!);
    }

    return null;
  }
}
