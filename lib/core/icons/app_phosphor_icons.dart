// Web icon parity lookup table.
//
// The web app (`thamkhao/deutschtiger-frontend`) imports icons from
// `@phosphor-icons/react` by PascalCase name (e.g. `import { House } from
// '@phosphor-icons/react'`). This file is a greppable name -> icon lookup so
// later migration phases can find the Flutter equivalent of a given web icon
// name without hunting through `phosphoricons_flutter`'s full icon set.
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
// site), call `PhosphorIcons.<name><Weight>` (e.g. `PhosphorIcons.houseFill`) directly
// instead of going through this class — `AppPhosphorIcons` only exists to
// answer "what's the Flutter name for web's `<X />`", not to gate access to
// non-default weights.
library;

import 'package:flutter/widgets.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Web icon name -> Flutter `IconData` (regular weight).
///
/// Keyed by the exact PascalCase name used in
/// `thamkhao/deutschtiger-frontend` import statements, exposed here as
/// lowerCamelCase getters (Dart convention), e.g. web's `<House />` maps to
/// `AppPhosphorIcons.house`.
class AppPhosphorIcons {
  AppPhosphorIcons._();

  static IconData get arrowClockwise => PhosphorIcons.arrowClockwise;
  static IconData get arrowCounterClockwise => PhosphorIcons.arrowCounterClockwise;
  static IconData get arrowDown => PhosphorIcons.arrowDown;
  static IconData get arrowLeft => PhosphorIcons.arrowLeft;
  static IconData get arrowRight => PhosphorIcons.arrowRight;
  static IconData get arrowsClockwise => PhosphorIcons.arrowsClockwise;
  static IconData get arrowUp => PhosphorIcons.arrowUp;
  static IconData get bell => PhosphorIcons.bell;
  static IconData get bookOpen => PhosphorIcons.bookOpen;
  static IconData get broadcast => PhosphorIcons.broadcast;
  static IconData get cards => PhosphorIcons.cards;
  static IconData get caretDoubleLeft => PhosphorIcons.caretDoubleLeft;
  static IconData get caretDoubleRight => PhosphorIcons.caretDoubleRight;
  static IconData get caretDown => PhosphorIcons.caretDown;
  static IconData get caretLeft => PhosphorIcons.caretLeft;
  static IconData get caretRight => PhosphorIcons.caretRight;
  static IconData get caretUp => PhosphorIcons.caretUp;
  static IconData get chartBar => PhosphorIcons.chartBar;
  static IconData get chatCircle => PhosphorIcons.chatCircle;
  static IconData get chatCircleDots => PhosphorIcons.chatCircleDots;
  static IconData get chatsCircle => PhosphorIcons.chatsCircle;
  static IconData get chatText => PhosphorIcons.chatText;
  static IconData get check => PhosphorIcons.check;
  static IconData get checkCircle => PhosphorIcons.checkCircle;
  static IconData get circle => PhosphorIcons.circle;
  static IconData get circleNotch => PhosphorIcons.circleNotch;
  static IconData get clock => PhosphorIcons.clock;
  static IconData get clockCounterClockwise => PhosphorIcons.clockCounterClockwise;
  static IconData get compass => PhosphorIcons.compass;
  static IconData get copy => PhosphorIcons.copy;
  static IconData get crown => PhosphorIcons.crown;
  static IconData get deviceMobile => PhosphorIcons.deviceMobile;
  static IconData get eraser => PhosphorIcons.eraser;
  static IconData get eye => PhosphorIcons.eye;
  static IconData get eyeSlash => PhosphorIcons.eyeSlash;
  static IconData get fastForward => PhosphorIcons.fastForward;
  static IconData get file => PhosphorIcons.file;
  static IconData get fileText => PhosphorIcons.fileText;
  static IconData get fire => PhosphorIcons.fire;
  static IconData get flag => PhosphorIcons.flag;
  static IconData get gameController => PhosphorIcons.gameController;
  static IconData get gear => PhosphorIcons.gear;
  static IconData get gearSix => PhosphorIcons.gearSix;
  static IconData get graduationCap => PhosphorIcons.graduationCap;
  static IconData get headphones => PhosphorIcons.headphones;
  static IconData get heart => PhosphorIcons.heart;
  static IconData get highlighterCircle => PhosphorIcons.highlighterCircle;
  static IconData get image => PhosphorIcons.image;
  static IconData get info => PhosphorIcons.info;
  static IconData get keyboard => PhosphorIcons.keyboard;
  static IconData get lightbulb => PhosphorIcons.lightbulb;
  static IconData get lightning => PhosphorIcons.lightning;
  static IconData get link => PhosphorIcons.link;
  static IconData get listBullets => PhosphorIcons.listBullets;
  static IconData get lock => PhosphorIcons.lock;
  static IconData get lockOpen => PhosphorIcons.lockOpen;
  static IconData get magnifyingGlass => PhosphorIcons.magnifyingGlass;
  static IconData get megaphone => PhosphorIcons.megaphone;
  static IconData get microphone => PhosphorIcons.microphone;
  static IconData get microphoneStage => PhosphorIcons.microphoneStage;
  static IconData get note => PhosphorIcons.note;
  static IconData get paperclip => PhosphorIcons.paperclip;
  static IconData get paperPlaneTilt => PhosphorIcons.paperPlaneTilt;
  static IconData get pause => PhosphorIcons.pause;
  static IconData get pencilLine => PhosphorIcons.pencilLine;
  static IconData get pencilSimple => PhosphorIcons.pencilSimple;
  static IconData get penNib => PhosphorIcons.penNib;
  static IconData get phone => PhosphorIcons.phone;
  static IconData get pictureInPicture => PhosphorIcons.pictureInPicture;
  static IconData get play => PhosphorIcons.play;
  static IconData get plus => PhosphorIcons.plus;
  static IconData get pushPin => PhosphorIcons.pushPin;
  static IconData get puzzlePiece => PhosphorIcons.puzzlePiece;
  static IconData get question => PhosphorIcons.question;
  static IconData get rewind => PhosphorIcons.rewind;
  static IconData get rocket => PhosphorIcons.rocket;
  static IconData get sealCheck => PhosphorIcons.sealCheck;
  static IconData get shuffle => PhosphorIcons.shuffle;
  static IconData get signOut => PhosphorIcons.signOut;
  static IconData get smiley => PhosphorIcons.smiley;
  static IconData get sparkle => PhosphorIcons.sparkle;
  static IconData get speakerHigh => PhosphorIcons.speakerHigh;
  static IconData get speakerSlash => PhosphorIcons.speakerSlash;
  static IconData get spinnerGap => PhosphorIcons.spinnerGap;
  static IconData get squaresFour => PhosphorIcons.squaresFour;
  static IconData get star => PhosphorIcons.star;
  static IconData get textAa => PhosphorIcons.textAa;
  static IconData get textAlignLeft => PhosphorIcons.textAlignLeft;
  static IconData get textStrikethrough => PhosphorIcons.textStrikethrough;
  static IconData get textUnderline => PhosphorIcons.textUnderline;
  static IconData get translate => PhosphorIcons.translate;
  static IconData get trash => PhosphorIcons.trash;
  static IconData get trophy => PhosphorIcons.trophy;
  static IconData get uploadSimple => PhosphorIcons.uploadSimple;
  static IconData get user => PhosphorIcons.user;
  static IconData get users => PhosphorIcons.users;
  static IconData get usersThree => PhosphorIcons.usersThree;
  static IconData get videoCamera => PhosphorIcons.videoCamera;
  static IconData get warning => PhosphorIcons.warning;
  static IconData get wifiSlash => PhosphorIcons.wifiSlash;
  static IconData get x => PhosphorIcons.x;
  static IconData get xCircle => PhosphorIcons.xCircle;
}
