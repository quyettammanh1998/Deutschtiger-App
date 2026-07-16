import 'package:deutschtiger/features/writing/domain/goethe_b1_writing_manifest.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GoetheB1WritingManifest.fromJson', () {
    test('counts only non-intro topics per Teil', () {
      final manifest = GoetheB1WritingManifest.fromJson({
        'teils': [
          {
            'teil': 1,
            'titleVi': 'Thư cá nhân',
            'topics': [
              {'slug': 'intro', 'isIntro': true},
              {'slug': 'a'},
              {'slug': 'b'},
            ],
          },
          {
            'teil': 2,
            'titleVi': 'Diễn đàn',
            'topics': [
              {'slug': 'c'},
            ],
          },
        ],
      });

      expect(manifest.teils, hasLength(2));
      expect(manifest.teils[0].teil, 1);
      expect(manifest.teils[0].titleVi, 'Thư cá nhân');
      expect(manifest.teils[0].topicCount, 2);
      expect(manifest.teils[1].topicCount, 1);
      expect(manifest.totalTopics, 3);
    });

    test('defaults to an empty teil list for a malformed payload', () {
      final manifest = GoetheB1WritingManifest.fromJson(const {});
      expect(manifest.teils, isEmpty);
      expect(manifest.totalTopics, 0);
    });
  });

  group('GoetheB1WritingResult.fromJson', () {
    test('parses teil and slug', () {
      final result = GoetheB1WritingResult.fromJson(const {'teil': 2, 'slug': 'mein-hobby'});
      expect(result.teil, 2);
      expect(result.slug, 'mein-hobby');
    });
  });
}
