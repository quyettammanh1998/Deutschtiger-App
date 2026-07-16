import 'package:deutschtiger/data/pronunciation/pronunciation_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UmlautItem.fromJson', () {
    test('parses all fields', () {
      final item = UmlautItem.fromJson(const {
        'id': 'u1',
        'word': 'schön',
        'ipa': 'ʃøːn',
        'umlaut': 'ö',
        'vi_meaning': 'đẹp',
        'vi_hint': 'tròn môi',
        'minimal_pair': 'schon',
      });

      expect(item.word, 'schön');
      expect(item.umlaut, 'ö');
      expect(item.minimalPair, 'schon');
    });

    test('defaults missing fields to empty strings', () {
      final item = UmlautItem.fromJson(const {});

      expect(item.word, '');
      expect(item.minimalPair, '');
    });
  });

  group('IchAchItem', () {
    test('isIchLaut reflects sound field', () {
      final ich = IchAchItem.fromJson(const {
        'sound': 'ich-laut',
        'word': 'ich',
      });
      final ach = IchAchItem.fromJson(const {
        'sound': 'ach-laut',
        'word': 'ach',
      });

      expect(ich.isIchLaut, isTrue);
      expect(ach.isIchLaut, isFalse);
    });
  });

  group('RPosition.fromWire', () {
    test('maps all four wire values', () {
      expect(RPosition.fromWire('initial'), RPosition.initial);
      expect(RPosition.fromWire('after-vowel'), RPosition.afterVowel);
      expect(
        RPosition.fromWire('consonant-cluster'),
        RPosition.consonantCluster,
      );
      expect(RPosition.fromWire('vocalic'), RPosition.vocalic);
    });

    test('falls back to initial for unknown values', () {
      expect(RPosition.fromWire('unknown'), RPosition.initial);
    });
  });

  group('SpStItem', () {
    test('isSp reflects cluster field', () {
      final sp = SpStItem.fromJson(const {'cluster': 'sp', 'word': 'sprechen'});
      final st = SpStItem.fromJson(const {'cluster': 'st', 'word': 'Straße'});

      expect(sp.isSp, isTrue);
      expect(st.isSp, isFalse);
    });
  });

  group('MinimalPairContrast.fromJson', () {
    test('parses contrast fields', () {
      final contrast = MinimalPairContrast.fromJson(const {
        'contrast_key': 'ich-ach',
        'focus_label': 'ich vs ach',
        'focus_label_vi': 'ich và ach',
        'pair_count': 12,
      });

      expect(contrast.contrastKey, 'ich-ach');
      expect(contrast.pairCount, 12);
    });
  });

  group('MinimalPair.fromJson', () {
    test('parses A/B word fields and tolerates null audio url', () {
      final pair = MinimalPair.fromJson(const {
        'id': 'p1',
        'contrast_key': 'ich-ach',
        'focus_label': 'ich vs ach',
        'focus_label_vi': 'ich và ach',
        'level': 'A2',
        'word_a_de': 'ich',
        'word_a_ipa': 'ɪç',
        'word_a_gloss_vi': 'tôi',
        'word_a_audio_url': null,
        'word_b_de': 'ach',
        'word_b_ipa': 'ax',
        'word_b_gloss_vi': 'ôi',
        'word_b_audio_url': null,
      });

      expect(pair.wordADe, 'ich');
      expect(pair.wordBDe, 'ach');
      expect(pair.wordAAudioUrl, isNull);
    });
  });
}
