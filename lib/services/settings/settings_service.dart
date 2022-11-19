import 'package:flutter/material.dart';

class SettingsService {
  static Rect screenSize(MediaQueryData mediaQuery) {
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    return Rect.fromLTWH(
      0,
      0,
      width - mediaQuery.padding.right,
      height,
    );
  }
}
