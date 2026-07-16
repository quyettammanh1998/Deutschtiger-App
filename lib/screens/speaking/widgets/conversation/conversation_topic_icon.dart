import 'package:flutter/widgets.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Maps a topic/category icon key (from `conversation_display.dart`) to a
/// Phosphor icon. Web parity: `components/conversation/conversation-topic-
/// icon.tsx`. One consistent monochrome line-icon set instead of emoji.
class ConversationTopicIcon extends StatelessWidget {
  const ConversationTopicIcon({
    super.key,
    required this.name,
    this.size = 24,
    this.color,
  });

  final String? name;
  final double size;
  final Color? color;

  static const Map<String, IconData> _icons = {
    'restaurant': PhosphorIcons.forkKnife,
    'einkaufen': PhosphorIcons.shoppingCart,
    'arzt': PhosphorIcons.stethoscope,
    'telefon': PhosphorIcons.phone,
    'fitness': PhosphorIcons.barbell,
    'nachbarn': PhosphorIcons.handWaving,
    'wegbeschreibung': PhosphorIcons.compass,
    'hotel': PhosphorIcons.bed,
    'bahnhof': PhosphorIcons.train,
    'reisen': PhosphorIcons.airplaneTilt,
    'bewerbung': PhosphorIcons.briefcase,
    'schule': PhosphorIcons.graduationCap,
    'bank': PhosphorIcons.bank,
    'behoerde': PhosphorIcons.fileText,
    'wohnung': PhosphorIcons.house,
    'post': PhosphorIcons.envelopeSimple,
    'daily': PhosphorIcons.house,
    'travel': PhosphorIcons.airplaneTilt,
    'work': PhosphorIcons.briefcase,
    'admin': PhosphorIcons.bank,
    'all': PhosphorIcons.squaresFour,
    'chat': PhosphorIcons.chatCircleText,
    'sparkle': PhosphorIcons.sparkle,
  };

  @override
  Widget build(BuildContext context) {
    final icon = (name != null ? _icons[name!.toLowerCase()] : null) ??
        PhosphorIcons.chatCircleText;
    return Icon(icon, size: size, color: color);
  }
}
