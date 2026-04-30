import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';

/// Safely loads a network image.
/// Shows a placeholder if URL is empty, null, or invalid (e.g. "file:///...")
class SafeNetworkImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;

  const SafeNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  bool _isValidUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final uri = Uri.tryParse(url);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isValidUrl(url)) {
      return placeholder ?? _DefaultPlaceholder(width: width, height: height);
    }

    return Image.network(
      url!,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) =>
          placeholder ?? _DefaultPlaceholder(width: width, height: height),
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          width: width,
          height: height,
          color: const Color(0xFFF0F0F0),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppTheme.primary,
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }
}

class _DefaultPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  const _DefaultPlaceholder({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF0F0F0),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppTheme.textLight,
          size: 28,
        ),
      ),
    );
  }
}
