import 'package:deutschtiger/features/writing/data/writing_draft_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('save(immediate: true) persists a draft loadable by a new store instance', () async {
    final store = WritingDraftStore('goethe-b1-writing:teil1:mein-hobby');
    store.save('Mein Hobby ist Lesen. Ich lese gern Bücher.', immediate: true);
    // Persist runs as a detached future; flush the microtask queue.
    await Future<void>.delayed(Duration.zero);

    final reloaded = WritingDraftStore('goethe-b1-writing:teil1:mein-hobby');
    final draft = await reloaded.load();

    expect(draft, isNotNull);
    expect(draft!.text, 'Mein Hobby ist Lesen. Ich lese gern Bücher.');
    expect(draft.wordCount, 8);
  });

  test('save() with blank text does not persist anything', () async {
    final store = WritingDraftStore('exam-x');
    store.save('   ', immediate: true);
    await Future<void>.delayed(Duration.zero);

    final draft = await store.load();
    expect(draft, isNull);
  });

  test('clear() removes a previously saved draft', () async {
    final store = WritingDraftStore('exam-y');
    store.save('some text here', immediate: true);
    await Future<void>.delayed(Duration.zero);
    expect(await store.load(), isNotNull);

    await store.clear();
    expect(await store.load(), isNull);
  });

  test('dispose() flushes a pending debounced save', () async {
    final store = WritingDraftStore('exam-z');
    store.save('pending text at dispose time'); // debounced, not yet persisted
    store.dispose();
    await Future<void>.delayed(Duration.zero);

    final reloaded = WritingDraftStore('exam-z');
    final draft = await reloaded.load();
    expect(draft?.text, 'pending text at dispose time');
  });

  test('drafts are scoped independently by examId', () async {
    final storeA = WritingDraftStore('exam-a');
    final storeB = WritingDraftStore('exam-b');
    storeA.save('text A', immediate: true);
    await Future<void>.delayed(Duration.zero);

    expect((await storeA.load())?.text, 'text A');
    expect(await storeB.load(), isNull);
  });
}
