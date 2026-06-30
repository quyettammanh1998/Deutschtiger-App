import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Logo con hổ DeutschTiger (SVG thật từ web public/deutsch-tiger-logo.svg).
/// Dùng ở login/signup/home để nhất quán thương hiệu.
class TigerLogo extends StatelessWidget {
  const TigerLogo({super.key, this.width = 96});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/logo/deutsch-tiger-logo.svg',
      width: width,
      semanticsLabel: 'DeutschTiger',
    );
  }
}

/// Chỉ mặt hổ (không có chữ) — dùng cho app bar, avatar mặc định.
class TigerIcon extends StatelessWidget {
  const TigerIcon({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/logo/tiger-icon.svg',
      width: size,
      height: size,
      semanticsLabel: 'DeutschTiger',
    );
  }
}
