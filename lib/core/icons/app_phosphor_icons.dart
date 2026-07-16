// Web icon parity lookup table.
//
// The web app (`thamkhao/deutschtiger-frontend`) imports icons from
// `@phosphor-icons/react` by PascalCase name (e.g. `import { House } from
// '@phosphor-icons/react'`). This file is a greppable name -> icon lookup so
// later migration phases can find the Flutter equivalent of a given web icon
// name without hunting through `phosphor_flutter`'s full icon set.
//
// Coverage: every distinct `@phosphor-icons/react` import found across
// `thamkhao/deutschtiger-frontend/src` (102 distinct icon names as of the
// 260716 UI-fidelity audit).
//
// Weight convention on web: `@phosphor-icons/react` icons default to the
// "regular" weight unless a `weight="..."` prop is passed. Across the web
// codebase, explicit weights are used as follows (most to least common):
// `bold` (298 usages), `regular` (136, redundant with the default), `fill`
// (75, mostly for "active/selected" states), `duotone` (5), `thin` (3).
// There is no global `IconContext` weight override, so "regular" is the
// correct default here too.
//
// Every getter below resolves the *regular* weight, matching web's default.
// When a call site needs a different weight (bold for emphasis, fill for
// selected/active state, matching the web `weight="..."` prop at that call
// site), call `PhosphorIcons.<name>(PhosphorIconsStyle.<weight>)` directly
// instead of going through this class — `AppPhosphorIcons` only exists to
// answer "what's the Flutter name for web's `<X />`", not to gate access to
// non-default weights.
library;

import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Web icon name -> Flutter `PhosphorIconData` (regular weight).
///
/// Keyed by the exact PascalCase name used in
/// `thamkhao/deutschtiger-frontend` import statements, exposed here as
/// lowerCamelCase getters (Dart convention), e.g. web's `<House />` maps to
/// `AppPhosphorIcons.house`.
class AppPhosphorIcons {
  AppPhosphorIcons._();

  static PhosphorIconData get arrowClockwise => PhosphorIcons.arrowClockwise();
  static PhosphorIconData get arrowCounterClockwise => PhosphorIcons.arrowCounterClockwise();
  static PhosphorIconData get arrowDown => PhosphorIcons.arrowDown();
  static PhosphorIconData get arrowLeft => PhosphorIcons.arrowLeft();
  static PhosphorIconData get arrowRight => PhosphorIcons.arrowRight();
  static PhosphorIconData get arrowsClockwise => PhosphorIcons.arrowsClockwise();
  static PhosphorIconData get arrowUp => PhosphorIcons.arrowUp();
  static PhosphorIconData get bell => PhosphorIcons.bell();
  static PhosphorIconData get bookOpen => PhosphorIcons.bookOpen();
  static PhosphorIconData get broadcast => PhosphorIcons.broadcast();
  static PhosphorIconData get cards => PhosphorIcons.cards();
  static PhosphorIconData get caretDoubleLeft => PhosphorIcons.caretDoubleLeft();
  static PhosphorIconData get caretDoubleRight => PhosphorIcons.caretDoubleRight();
  static PhosphorIconData get caretDown => PhosphorIcons.caretDown();
  static PhosphorIconData get caretLeft => PhosphorIcons.caretLeft();
  static PhosphorIconData get caretRight => PhosphorIcons.caretRight();
  static PhosphorIconData get caretUp => PhosphorIcons.caretUp();
  static PhosphorIconData get chartBar => PhosphorIcons.chartBar();
  static PhosphorIconData get chatCircle => PhosphorIcons.chatCircle();
  static PhosphorIconData get chatCircleDots => PhosphorIcons.chatCircleDots();
  static PhosphorIconData get chatsCircle => PhosphorIcons.chatsCircle();
  static PhosphorIconData get chatText => PhosphorIcons.chatText();
  static PhosphorIconData get check => PhosphorIcons.check();
  static PhosphorIconData get checkCircle => PhosphorIcons.checkCircle();
  static PhosphorIconData get circle => PhosphorIcons.circle();
  static PhosphorIconData get circleNotch => PhosphorIcons.circleNotch();
  static PhosphorIconData get clock => PhosphorIcons.clock();
  static PhosphorIconData get clockCounterClockwise => PhosphorIcons.clockCounterClockwise();
  static PhosphorIconData get compass => PhosphorIcons.compass();
  static PhosphorIconData get copy => PhosphorIcons.copy();
  static PhosphorIconData get crown => PhosphorIcons.crown();
  static PhosphorIconData get deviceMobile => PhosphorIcons.deviceMobile();
  static PhosphorIconData get eraser => PhosphorIcons.eraser();
  static PhosphorIconData get eye => PhosphorIcons.eye();
  static PhosphorIconData get eyeSlash => PhosphorIcons.eyeSlash();
  static PhosphorIconData get fastForward => PhosphorIcons.fastForward();
  static PhosphorIconData get file => PhosphorIcons.file();
  static PhosphorIconData get fileText => PhosphorIcons.fileText();
  static PhosphorIconData get fire => PhosphorIcons.fire();
  static PhosphorIconData get flag => PhosphorIcons.flag();
  static PhosphorIconData get gameController => PhosphorIcons.gameController();
  static PhosphorIconData get gear => PhosphorIcons.gear();
  static PhosphorIconData get gearSix => PhosphorIcons.gearSix();
  static PhosphorIconData get graduationCap => PhosphorIcons.graduationCap();
  static PhosphorIconData get headphones => PhosphorIcons.headphones();
  static PhosphorIconData get heart => PhosphorIcons.heart();
  static PhosphorIconData get highlighterCircle => PhosphorIcons.highlighterCircle();
  static PhosphorIconData get image => PhosphorIcons.image();
  static PhosphorIconData get info => PhosphorIcons.info();
  static PhosphorIconData get keyboard => PhosphorIcons.keyboard();
  static PhosphorIconData get lightbulb => PhosphorIcons.lightbulb();
  static PhosphorIconData get lightning => PhosphorIcons.lightning();
  static PhosphorIconData get link => PhosphorIcons.link();
  static PhosphorIconData get listBullets => PhosphorIcons.listBullets();
  static PhosphorIconData get lock => PhosphorIcons.lock();
  static PhosphorIconData get lockOpen => PhosphorIcons.lockOpen();
  static PhosphorIconData get magnifyingGlass => PhosphorIcons.magnifyingGlass();
  static PhosphorIconData get megaphone => PhosphorIcons.megaphone();
  static PhosphorIconData get microphone => PhosphorIcons.microphone();
  static PhosphorIconData get microphoneStage => PhosphorIcons.microphoneStage();
  static PhosphorIconData get note => PhosphorIcons.note();
  static PhosphorIconData get paperclip => PhosphorIcons.paperclip();
  static PhosphorIconData get paperPlaneTilt => PhosphorIcons.paperPlaneTilt();
  static PhosphorIconData get pause => PhosphorIcons.pause();
  static PhosphorIconData get pencilLine => PhosphorIcons.pencilLine();
  static PhosphorIconData get pencilSimple => PhosphorIcons.pencilSimple();
  static PhosphorIconData get penNib => PhosphorIcons.penNib();
  static PhosphorIconData get phone => PhosphorIcons.phone();
  // Note: phosphor_flutter names this `pictureInpicture` (lowercase "p"),
  // not `pictureInPicture` — kept the web-facing getter name camelCase to
  // match convention, but the underlying call must use the package's exact
  // casing.
  static PhosphorIconData get pictureInPicture =>
      PhosphorIcons.pictureInpicture();
  static PhosphorIconData get play => PhosphorIcons.play();
  static PhosphorIconData get plus => PhosphorIcons.plus();
  static PhosphorIconData get pushPin => PhosphorIcons.pushPin();
  static PhosphorIconData get puzzlePiece => PhosphorIcons.puzzlePiece();
  static PhosphorIconData get question => PhosphorIcons.question();
  static PhosphorIconData get rewind => PhosphorIcons.rewind();
  static PhosphorIconData get rocket => PhosphorIcons.rocket();
  static PhosphorIconData get sealCheck => PhosphorIcons.sealCheck();
  static PhosphorIconData get shuffle => PhosphorIcons.shuffle();
  static PhosphorIconData get signOut => PhosphorIcons.signOut();
  static PhosphorIconData get smiley => PhosphorIcons.smiley();
  static PhosphorIconData get sparkle => PhosphorIcons.sparkle();
  static PhosphorIconData get speakerHigh => PhosphorIcons.speakerHigh();
  static PhosphorIconData get speakerSlash => PhosphorIcons.speakerSlash();
  static PhosphorIconData get spinnerGap => PhosphorIcons.spinnerGap();
  static PhosphorIconData get squaresFour => PhosphorIcons.squaresFour();
  static PhosphorIconData get star => PhosphorIcons.star();
  static PhosphorIconData get textAa => PhosphorIcons.textAa();
  static PhosphorIconData get textAlignLeft => PhosphorIcons.textAlignLeft();
  static PhosphorIconData get textStrikethrough => PhosphorIcons.textStrikethrough();
  static PhosphorIconData get textUnderline => PhosphorIcons.textUnderline();
  static PhosphorIconData get translate => PhosphorIcons.translate();
  static PhosphorIconData get trash => PhosphorIcons.trash();
  static PhosphorIconData get trophy => PhosphorIcons.trophy();
  static PhosphorIconData get uploadSimple => PhosphorIcons.uploadSimple();
  static PhosphorIconData get user => PhosphorIcons.user();
  static PhosphorIconData get users => PhosphorIcons.users();
  static PhosphorIconData get usersThree => PhosphorIcons.usersThree();
  static PhosphorIconData get videoCamera => PhosphorIcons.videoCamera();
  static PhosphorIconData get warning => PhosphorIcons.warning();
  static PhosphorIconData get wifiSlash => PhosphorIcons.wifiSlash();
  static PhosphorIconData get x => PhosphorIcons.x();
  static PhosphorIconData get xCircle => PhosphorIcons.xCircle();
}
