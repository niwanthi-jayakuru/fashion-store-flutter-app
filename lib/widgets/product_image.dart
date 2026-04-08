import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.product,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorBuilder,
    this.loadingBuilder,
  });

  final Product product;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ImageErrorWidgetBuilder? errorBuilder;
  final ImageLoadingBuilder? loadingBuilder;

  @override
  Widget build(BuildContext context) {
    final url = product.displayImageUrl;
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      headers: Product.networkHeadersFor(url),
      errorBuilder: errorBuilder ??
          (context, error, stackTrace) =>
              const Icon(Icons.image_not_supported),
      loadingBuilder: loadingBuilder,
    );
  }
}
