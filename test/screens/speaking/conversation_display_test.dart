import 'package:deutschtiger/data/speech/conversation_display.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('slugifyTopic', () {
    test('strips diacritics and slugifies', () {
      expect(slugifyTopic('Giới thiệu bản thân'), 'gioi-thieu-ban-than');
    });

    test('falls back to chu-de for empty/non-alphanumeric input', () {
      expect(slugifyTopic('!!!'), 'chu-de');
    });
  });

  group('buildCustomConversationSlug / parseCustomConversationSlug', () {
    test('round-trips topic + level through the slug', () {
      final slug = buildCustomConversationSlug('Phỏng vấn xin việc', 'B1');
      expect(slug, 'phong-van-xin-viec-b1');

      final parsed = parseCustomConversationSlug(slug);
      expect(parsed, isNotNull);
      expect(parsed!.level, 'B1');
      expect(parsed.topic, 'phong van xin viec');
    });

    test('parseCustomConversationSlug returns null for empty slug', () {
      expect(parseCustomConversationSlug(''), isNull);
      expect(parseCustomConversationSlug(null), isNull);
    });

    test('parseCustomConversationSlug defaults to B1 when no level suffix', () {
      final parsed = parseCustomConversationSlug('mot-chu-de');
      expect(parsed!.level, 'B1');
      expect(parsed.topic, 'mot chu de');
    });
  });

  group('normalizeConversationLevel', () {
    test('accepts known CEFR levels case-insensitively', () {
      expect(normalizeConversationLevel('b2'), 'B2');
      expect(normalizeConversationLevel('C1'), 'C1');
    });

    test('falls back to B1 for unknown/empty input', () {
      expect(normalizeConversationLevel('xx'), 'B1');
      expect(normalizeConversationLevel(null), 'B1');
    });
  });

  group('buildCustomConversationScenario', () {
    test('synthesizes a custom scenario carrying the topic + level', () {
      final scenario = buildCustomConversationScenario('Đặt phòng khách sạn', 'A2');
      expect(scenario.id, customScenarioId);
      expect(scenario.isCustom, isTrue);
      expect(scenario.titleVi, 'Đặt phòng khách sạn');
      expect(scenario.level, 'A2');
      expect(scenario.starterPromptDe, contains('Đặt phòng khách sạn'));
    });
  });

  group('getScenarioDisplay', () {
    test('resolves a known scenario id', () {
      final display = getScenarioDisplay('restaurant');
      expect(display.category, 'daily');
      expect(display.icon, 'restaurant');
    });

    test('falls back to the default display for unknown ids', () {
      final display = getScenarioDisplay('does-not-exist');
      expect(display.category, 'daily');
      expect(display.icon, 'chat');
    });
  });
}
