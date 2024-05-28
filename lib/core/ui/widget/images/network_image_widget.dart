import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../config/asset_path.dart';

class NetworkImageWidget extends StatelessWidget {
  final String? imageUrl;
  final Size? size;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final BoxShape? shape;

  const NetworkImageWidget({
    super.key,
    this.imageUrl,
    this.size,
    this.fit,
    this.borderRadius,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return PlaceholderImageWidget(
        size: size,
        fit: fit,
        borderRadius: borderRadius,
        shape: shape,
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
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            shape: shape ?? BoxShape.rectangle,
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
            ),
          ),
        );
      },
      placeholder: (context, url) {
        return PlaceholderImageWidget(
          size: size,
          fit: fit,
          borderRadius: borderRadius,
          shape: shape,
        );
      },
      errorWidget: (context, url, error) {
        return PlaceholderImageWidget(
          size: size,
          fit: fit,
          borderRadius: borderRadius,
          shape: shape,
        );
      },
    );
  }
}

class PlaceholderImageWidget extends StatelessWidget {
  final Size? size;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final BoxShape? shape;

  const PlaceholderImageWidget({
    super.key,
    this.size,
    this.fit,
    this.borderRadius,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size?.width,
      height: size?.height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        shape: shape ?? BoxShape.rectangle,
        image: DecorationImage(
          image: AssetImage(
            AssetImagesPath.placeholder,
          ),
          fit: fit,
        ),
      ),
    );
  }
}
