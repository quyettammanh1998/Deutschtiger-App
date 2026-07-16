// Public API for the app's bespoke feature icons.
//
// These mirror the web app's `FEATURE_ICONS` map
// (`thamkhao/deutschtiger-frontend/src/lib/shared/feature-icons.tsx`) —
// icons shared across the dashboard tiles, sidebar, and bottom-nav that
// aren't in the Phosphor set (see `app_phosphor_icons.dart` for the
// Phosphor lookup table instead).
//
// Rendered from inline SVG strings (`feature_icon_svgs.dart`) via
// `flutter_svg`'s `SvgPicture.string`, so no asset registration or pubspec
// change is needed. Color is applied with a `srcIn` color filter, which
// replaces every opaque pixel regardless of the SVG's own `currentColor`
// fill/stroke — matching how the web version inherits `currentColor` from
// its parent's text color.
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'feature_icon_svgs.dart';

/// Bespoke feature icons not covered by Phosphor. One method per icon,
/// named to match the web `FeatureIconKey` export names 1:1.
class AppIcons {
  AppIcons._();

  static Widget _render(String key, {required double size, Color? color}) {
    final svg = kFeatureIconSvgs[key];
    assert(svg != null, 'Unknown feature icon key: "$key"');
    return SvgPicture.string(
      svg!,
      width: size,
      height: size,
      colorFilter:
          color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  static Widget home({double size = 24, Color? color}) =>
      _render('home', size: size, color: color);

  static Widget exams({double size = 24, Color? color}) =>
      _render('exams', size: size, color: color);

  static Widget dailyReview({double size = 24, Color? color}) =>
      _render('dailyReview', size: size, color: color);

  static Widget vocabulary({double size = 24, Color? color}) =>
      _render('vocabulary', size: size, color: color);

  static Widget notes({double size = 24, Color? color}) =>
      _render('notes', size: size, color: color);

  static Widget conversationHub({double size = 24, Color? color}) =>
      _render('conversationHub', size: size, color: color);

  static Widget games({double size = 24, Color? color}) =>
      _render('games', size: size, color: color);

  static Widget course({double size = 24, Color? color}) =>
      _render('course', size: size, color: color);

  static Widget sentenceBuilder({double size = 24, Color? color}) =>
      _render('sentenceBuilder', size: size, color: color);

  static Widget listening({double size = 24, Color? color}) =>
      _render('listening', size: size, color: color);

  static Widget youtube({double size = 24, Color? color}) =>
      _render('youtube', size: size, color: color);

  static Widget interview({double size = 24, Color? color}) =>
      _render('interview', size: size, color: color);

  static Widget news({double size = 24, Color? color}) =>
      _render('news', size: size, color: color);

  static Widget affiliate({double size = 24, Color? color}) =>
      _render('affiliate', size: size, color: color);

  static Widget learn({double size = 24, Color? color}) =>
      _render('learn', size: size, color: color);
}
