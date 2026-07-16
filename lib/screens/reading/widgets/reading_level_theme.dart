import 'package:flutter/material.dart';

/// Per-level visual theme for the Reading surface (level cards + level
/// detail header) — mirrors web `reading-level-theme.ts`. Reading spans
/// A1..C2 (one level more than grammar).
const List<String> kReadingLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

class ReadingLevelTheme {
  const ReadingLevelTheme({
    required this.emoji,
    required this.label,
    required this.desc,
    required this.headerFrom,
    required this.headerTo,
    required this.ring,
    required this.badgeBg,
    required this.badgeText,
  });

  final String emoji;
  final String label;
  final String desc;
  final Color headerFrom;
  final Color headerTo;
  final Color ring;
  final Color badgeBg;
  final Color badgeText;
}

const Map<String, ReadingLevelTheme> kReadingLevelTheme = {
  'A1': ReadingLevelTheme(
    emoji: '🌱',
    label: 'Sơ cấp 1',
    desc: 'Bắt đầu đọc truyện đơn giản!',
    headerFrom: Color(0xFF10B981),
    headerTo: Color(0xFF059669),
    ring: Color(0xFF10B981),
    badgeBg: Color(0xFFD1FAE5),
    badgeText: Color(0xFF047857),
  ),
  'A2': ReadingLevelTheme(
    emoji: '🚀',
    label: 'Sơ cấp 2',
    desc: 'Truyện dài hơn một chút!',
    headerFrom: Color(0xFF0EA5E9),
    headerTo: Color(0xFF0284C7),
    ring: Color(0xFF0EA5E9),
    badgeBg: Color(0xFFE0F2FE),
    badgeText: Color(0xFF0369A1),
  ),
  'B1': ReadingLevelTheme(
    emoji: '🎯',
    label: 'Trung cấp 1',
    desc: 'Câu chuyện đa dạng hơn!',
    headerFrom: Color(0xFF8B5CF6),
    headerTo: Color(0xFF7C3AED),
    ring: Color(0xFF8B5CF6),
    badgeBg: Color(0xFFEDE9FE),
    badgeText: Color(0xFF6D28D9),
  ),
  'B2': ReadingLevelTheme(
    emoji: '🏆',
    label: 'Trung cấp 2',
    desc: 'Văn phong phức tạp hơn!',
    headerFrom: Color(0xFFF59E0B),
    headerTo: Color(0xFFD97706),
    ring: Color(0xFFF59E0B),
    badgeBg: Color(0xFFFEF3C7),
    badgeText: Color(0xFFB45309),
  ),
  'C1': ReadingLevelTheme(
    emoji: '⭐',
    label: 'Cao cấp 1',
    desc: 'Chủ đề học thuật, trừu tượng!',
    headerFrom: Color(0xFFF43F5E),
    headerTo: Color(0xFFE11D48),
    ring: Color(0xFFF43F5E),
    badgeBg: Color(0xFFFFE4E6),
    badgeText: Color(0xFFBE123C),
  ),
  'C2': ReadingLevelTheme(
    emoji: '👑',
    label: 'Bậc thầy',
    desc: 'Trình độ tinh thông!',
    headerFrom: Color(0xFF6366F1),
    headerTo: Color(0xFF4F46E5),
    ring: Color(0xFF6366F1),
    badgeBg: Color(0xFFE0E7FF),
    badgeText: Color(0xFF4338CA),
  ),
};

ReadingLevelTheme readingLevelTheme(String level) =>
    kReadingLevelTheme[level.toUpperCase()] ?? kReadingLevelTheme['A1']!;
