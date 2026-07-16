// Internal SVG source data backing `AppIcons` (see `app_icons.dart`).
//
// Ported 1:1 from the web app's bespoke icon set at
// `thamkhao/deutschtiger-frontend/src/lib/shared/feature-icons.tsx`. That
// file documents *why* these are hand-drawn instead of picked from
// Phosphor: they're shared across the dashboard tiles, desktop sidebar, and
// mobile bottom-nav, and need to theme via `currentColor` in both light and
// dark mode (unlike the raster `.webp` icons they replaced).
//
// Two glyph families, matching the web source:
//  - 256-viewBox solid fills (`fill="currentColor"`).
//  - 24-viewBox stroked line icons (`stroke="currentColor"`), some with an
//    extra small solid-fill accent path (e.g. the sparkle on
//    sentenceBuilder/conversationHub).
//
// Do not use these strings directly — go through `AppIcons` in
// `app_icons.dart`, which renders them via `SvgPicture.string` with a
// caller-supplied size/color.
library;

String _fillIcon(String pathData) =>
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256">'
    '<path fill="currentColor" d="$pathData"/></svg>';

String _strokeIcon(
  List<String> strokedPaths, {
  double width = 1.7,
  List<String> filledPaths = const [],
}) {
  final strokes = strokedPaths.map((d) => '<path d="$d"/>').join();
  final fills = filledPaths
      .map((d) => '<path d="$d" fill="currentColor" stroke="none"/>')
      .join();
  return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" '
      'fill="none" stroke="currentColor" stroke-width="$width" '
      'stroke-linecap="round" stroke-linejoin="round">$strokes$fills</svg>';
}

// `interview` mixes a <rect> with <path>s, so it's built manually rather
// than through `_strokeIcon`.
const String _kInterviewSvg =
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" '
    'stroke="currentColor" stroke-width="1.6" stroke-linecap="round" '
    'stroke-linejoin="round">'
    '<rect x="9" y="2.5" width="6" height="11" rx="3"/>'
    '<path d="M5 11a7 7 0 0 0 14 0"/>'
    '<path d="M12 18v3"/>'
    '<path d="M8.5 21h7"/>'
    '</svg>';

/// Feature icon key (matches `FeatureIconKey` on web) -> raw SVG source.
final Map<String, String> kFeatureIconSvgs = {
  'home': _fillIcon(
    'M222.14,105.85l-80-80a20,20,0,0,0-28.28,0l-80,80A19.86,19.86,0,0,0,28,120v96a12,12,0,0,0,12,12h64a12,12,0,0,0,12-12V164h24v52a12,12,0,0,0,12,12h64a12,12,0,0,0,12-12V120A19.86,19.86,0,0,0,222.14,105.85ZM204,204H164V152a12,12,0,0,0-12-12H104a12,12,0,0,0-12,12v52H52V121.65l76-76,76,76Z',
  ),
  'exams': _fillIcon(
    'M249.8,85.49l-116-64a12,12,0,0,0-11.6,0l-116,64a12,12,0,0,0,0,21l21.8,12v47.76a19.89,19.89,0,0,0,5.09,13.32C46.63,194.7,77,220,128,220a136.88,136.88,0,0,0,40-5.75V240a12,12,0,0,0,24,0V204.12a119.53,119.53,0,0,0,30.91-24.51A19.89,19.89,0,0,0,228,166.29V118.53l21.8-12a12,12,0,0,0,0-21ZM128,45.71,219.16,96,186,114.3a1.88,1.88,0,0,1-.18-.12l-52-28.69a12,12,0,0,0-11.6,21l39,21.49L128,146.3,36.84,96ZM128,196c-40.42,0-64.65-19.07-76-31.27v-33l70.2,38.74a12,12,0,0,0,11.6,0L168,151.64v37.23A110.46,110.46,0,0,1,128,196Zm76-31.27a93.21,93.21,0,0,1-12,10.81V138.39l12-6.62Z',
  ),
  'dailyReview': _fillIcon(
    'M228,48V96a12,12,0,0,1-12,12H168a12,12,0,0,1,0-24h19l-7.8-7.8a75.55,75.55,0,0,0-53.32-22.26h-.43A75.49,75.49,0,0,0,72.39,75.57,12,12,0,1,1,55.61,58.41a99.38,99.38,0,0,1,69.87-28.47H126A99.42,99.42,0,0,1,196.2,59.23L204,67V48a12,12,0,0,1,24,0ZM183.61,180.43a75.49,75.49,0,0,1-53.09,21.63h-.43A75.55,75.55,0,0,1,76.77,179.8L69,172H88a12,12,0,0,0,0-24H40a12,12,0,0,0-12,12v48a12,12,0,0,0,24,0V189l7.8,7.8A99.42,99.42,0,0,0,130,226.06h.56a99.38,99.38,0,0,0,69.87-28.47,12,12,0,0,0-16.78-17.16Z',
  ),
  'vocabulary': _strokeIcon(
    [
      'm10.5 21 5.25-11.25L21 21m-9-3h6M3.75 4.5h5.25M6.375 4.5v13.5m0 0c-1.657 0-3-1.007-3-2.25M9.375 15c0 1.243-1.343 2.25-3 2.25',
    ],
    width: 1.9,
  ),
  'notes': _strokeIcon(
    [
      'M17.593 3.322c1.1.128 1.907 1.077 1.907 2.185V21L12 17.25 4.5 21V5.507c0-1.108.806-2.057 1.907-2.185a48.507 48.507 0 0 1 11.186 0Z',
    ],
    width: 1.9,
  ),
  'conversationHub': _strokeIcon(
    [
      'M7.5 8h6M7.5 11.5h3.5',
      'M20 11.5a7.5 7.5 0 0 1-10.9 6.68L4 19l1-3.9A7.5 7.5 0 1 1 20 11.5Z',
    ],
    width: 1.6,
    filledPaths: [
      'M17.2 3.3l.5 1.3 1.3.5-1.3.5-.5 1.3-.5-1.3L15.4 5l1.3-.5.5-1.2Z',
    ],
  ),
  'games': _fillIcon(
    'M176,116a12,12,0,0,1,12-12h4a12,12,0,0,1,0,24h-4A12,12,0,0,1,176,116Zm-20,20a12,12,0,1,0,12,12A12,12,0,0,0,156,136ZM88,104H80V96a12,12,0,0,0-24,0v8H48a12,12,0,0,0,0,24h8v8a12,12,0,0,0,24,0v-8h8a12,12,0,0,0,0-24Zm147.4,72.53A44,44,0,0,1,152.81,192H103.19A44,44,0,0,1,20.6,176.53l-.09-.28L4.92,120.9a4.29,4.29,0,0,1-.13-.48A60,60,0,0,1,63.55,48H192a60,60,0,0,1,58.79,72.42,4.29,4.29,0,0,1-.13.48ZM227.65,114.53A36,36,0,0,0,192,72H63.55a36,36,0,0,0-35.2,42.53l0,.15L43.44,169.7A20,20,0,0,0,82,163.75,12,12,0,0,1,93.65,155h68.7A12,12,0,0,1,174,163.75a20,20,0,0,0,38.57,5.95l15.08-55Z',
  ),
  'course': _fillIcon(
    'M232,44H160a43.86,43.86,0,0,0-32,13.85A43.86,43.86,0,0,0,96,44H24A12,12,0,0,0,12,56V200a12,12,0,0,0,12,12H96a20,20,0,0,1,20,20,12,12,0,0,0,24,0,20,20,0,0,1,20-20h72a12,12,0,0,0,12-12V56A12,12,0,0,0,232,44ZM96,188H36V68H96a20,20,0,0,1,20,20V192.81A43.79,43.79,0,0,0,96,188Zm124,0H160a43.71,43.71,0,0,0-20,4.83V88a20,20,0,0,1,20-20h60ZM164,96h32a12,12,0,0,1,0,24H164a12,12,0,0,1,0-24Zm44,52a12,12,0,0,1-12,12H164a12,12,0,0,1,0-24h32A12,12,0,0,1,208,148Z',
  ),
  // Viet AI (sentence-builder): pencil + sparkle - "AI-assisted writing".
  'sentenceBuilder': _strokeIcon(
    [
      'M16.862 4.487l1.687-1.688a1.875 1.875 0 1 1 2.652 2.652L10.582 16.07a4.5 4.5 0 0 1-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 0 1 1.13-1.897l8.932-8.931Z',
    ],
    width: 1.7,
    filledPaths: [
      'M18.8 13.3l.5 1.35 1.35.5-1.35.5-.5 1.35-.5-1.35-1.35-.5 1.35-.5.5-1.35Z',
    ],
  ),
  'listening': _strokeIcon(
    [
      'M19.114 5.636a9 9 0 0 1 0 12.728M16.463 8.288a5.25 5.25 0 0 1 0 7.424M6.75 8.25l4.72-4.72a.75.75 0 0 1 1.28.53v15.88a.75.75 0 0 1-1.28.53l-4.72-4.72H4.51c-.88 0-1.704-.507-1.938-1.354A9.009 9.009 0 0 1 2.25 12c0-.83.112-1.633.322-2.396C2.806 8.756 3.63 8.25 4.51 8.25H6.75Z',
    ],
    width: 1.5,
  ),
  'youtube': _fillIcon(
    'M226.29,74.31A24.16,24.16,0,0,0,209.35,57.5C194.4,53.5,128,53.5,128,53.5s-66.4,0-81.35,4A24.16,24.16,0,0,0,29.71,74.31C25.75,89.32,25.75,128,25.75,128s0,38.68,4,53.69A24.16,24.16,0,0,0,46.65,198.5c15,4,81.35,4,81.35,4s66.4,0,81.35-4a24.16,24.16,0,0,0,16.94-16.81c4-15,4-53.69,4-53.69S230.25,89.32,226.29,74.31ZM107,157V99l50,29Z',
  ),
  'interview': _kInterviewSvg,
  'news': _fillIcon(
    'M228,44H28A12,12,0,0,0,16,56V192a20,20,0,0,0,20,20H220a20,20,0,0,0,20-20V56A12,12,0,0,0,228,44ZM216,188H40V68H216ZM84,104a12,12,0,0,1,12-12h88a12,12,0,0,1,0,24H96A12,12,0,0,1,84,104Zm0,40a12,12,0,0,1,12-12h88a12,12,0,0,1,0,24H96A12,12,0,0,1,84,144ZM52,104A12,12,0,0,1,64,92h0a12,12,0,0,1,0,24h0A12,12,0,0,1,52,104Zm0,40a12,12,0,0,1,12-12h0a12,12,0,0,1,0,24h0A12,12,0,0,1,52,144Z',
  ),
  'affiliate': _strokeIcon(
    [
      'M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12Z',
    ],
    width: 1.6,
  ),
  'learn': _fillIcon(
    'M208,136a16,16,0,1,0-16-16A16,16,0,0,0,208,136ZM48,80A16,16,0,1,0,32,96,16,16,0,0,0,48,80Zm88,96a16,16,0,1,0-16-16A16,16,0,0,0,136,176Zm68-116a12,12,0,0,0-8.49,3.51L148,111.05A44,44,0,0,0,96.4,172H72a20,20,0,0,1-20-20v-4a12,12,0,0,0-24,0v4a44,44,0,0,0,44,44h24.4A44,44,0,0,0,152,232a44,44,0,1,0,0-88,44,44,0,0,0-16.15,3.06l44.66-47.55A12,12,0,0,0,204,60ZM152,208a20,20,0,1,1,20-20A20,20,0,0,1,152,208Z',
  ),
};
