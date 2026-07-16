/// Catalog of generic writing-practice offerings across providers/levels —
/// web parity `src/lib/writing/writing-catalog.ts`. Single source of truth
/// for the `/luyen-viet` catalog page and the generic
/// `/exams/{provider}-{level}/writing` routes.
///
/// Content itself is data-driven from the backend `GET /exams/official`
/// endpoint (see [OfficialWritingTopicRepository]) — adding an offering here
/// only surfaces it in the UI.
class WritingOffering {
  const WritingOffering({
    required this.provider,
    required this.level,
    required this.label,
  });

  /// `goethe` | `telc` | `osd`.
  final String provider;

  /// e.g. `a1`, `b2`.
  final String level;

  /// Human label, e.g. `Goethe B2`, `telc B1`, `ÖSD B2`.
  final String label;

  /// URL segment `${provider}-${level}` (e.g. `goethe-b2`).
  String get providerLevel => '$provider-$level';
}

const Map<String, String> _kProviderLabel = {
  'goethe': 'Goethe',
  'telc': 'telc',
  'osd': 'ÖSD',
};

WritingOffering _offering(String provider, String level) => WritingOffering(
  provider: provider,
  level: level,
  label: '${_kProviderLabel[provider] ?? provider} ${level.toUpperCase()}',
);

/// Available writing offerings. Order = display order in the catalog.
final List<WritingOffering> kWritingCatalog = [
  _offering('goethe', 'a1'),
  _offering('goethe', 'a2'),
  _offering('goethe', 'b1'),
  _offering('goethe', 'b2'),
  _offering('goethe', 'c1'),
  _offering('telc', 'b1'),
  _offering('telc', 'b2'),
  _offering('osd', 'b2'),
];

/// Resolve a `${provider}-${level}` URL segment to a known offering, or null.
WritingOffering? findWritingOffering(String providerLevel) {
  for (final o in kWritingCatalog) {
    if (o.providerLevel == providerLevel) return o;
  }
  return null;
}
