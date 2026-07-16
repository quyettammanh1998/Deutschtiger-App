/// Static list of common B1 writing mistakes for the sprint cheatsheet — web
/// parity `common-mistakes.ts`. Long-form DE/VI pedagogical content: approved
/// inline exception (not UI chrome), same rationale as the Redemittel
/// cheatsheet copy per the plan's data rules.
class CommonMistake {
  const CommonMistake({required this.category, required this.wrong, required this.correct, required this.rule});

  final String category;
  final String wrong;
  final String correct;
  final String rule;
}

const List<CommonMistake> kCommonMistakes = [
  CommonMistake(
    category: 'Wortstellung',
    wrong: 'Ich habe gestern gegangen ins Kino.',
    correct: 'Ich bin gestern ins Kino gegangen.',
    rule: 'Verb-End im Nebensatz; Hilfsverb "sein" bei Bewegungsverben',
  ),
  CommonMistake(
    category: 'Komma vor "dass"',
    wrong: 'Ich denke dass du recht hast.',
    correct: 'Ich denke, dass du recht hast.',
    rule: 'Vor Konjunktionen (dass, weil, ob, wenn...) immer Komma',
  ),
  CommonMistake(
    category: 'Artikel',
    wrong: 'Ich habe eine Problem.',
    correct: 'Ich habe ein Problem.',
    rule: 'das Problem → ein Problem (Neutrum, unbestimmter Artikel)',
  ),
  CommonMistake(
    category: 'Kasus Akkusativ',
    wrong: 'Ich besuche der Arzt.',
    correct: 'Ich besuche den Arzt.',
    rule: 'Nach transitiven Verben steht das Objekt im Akkusativ',
  ),
  CommonMistake(
    category: 'Kasus Dativ',
    wrong: 'Ich helfe dein Freund.',
    correct: 'Ich helfe deinem Freund.',
    rule: 'helfen, danken, gratulieren → immer Dativ',
  ),
  CommonMistake(
    category: 'Präposition + Kasus',
    wrong: 'Ich warte seit ein Jahr.',
    correct: 'Ich warte seit einem Jahr.',
    rule: 'seit + Dativ; "ein" wird zu "einem" im Dativ Maskulin/Neutrum',
  ),
  CommonMistake(
    category: 'Trennbare Verben',
    wrong: 'Ich anrufe dich morgen.',
    correct: 'Ich rufe dich morgen an.',
    rule: 'Trennbares Präfix ans Satzende: an|rufen → ich rufe … an',
  ),
  CommonMistake(
    category: 'Reflexivpronomen',
    wrong: 'Ich freue mich über deinen Brief.',
    correct: 'Ich freue mich über deinen Brief. ✓',
    rule: 'sich freuen über + Akkusativ — oft korrekt, aber Pronomen nicht vergessen',
  ),
  CommonMistake(
    category: 'Adjektivendung Nominativ',
    wrong: 'Das ist ein schöner Tag.',
    correct: 'Das ist ein schöner Tag. ✓',
    rule: 'Nach unbestimmtem Artikel: -er (Mask.), -e (Fem./Neutr.)',
  ),
  CommonMistake(
    category: 'Konjunktiv II (Höflichkeit)',
    wrong: 'Ich will wissen, ob Sie kommen.',
    correct: 'Ich würde gerne wissen, ob Sie kommen könnten.',
    rule: 'In formellen Anfragen: würde + Infinitiv oder könnten/hätten',
  ),
  CommonMistake(
    category: 'Großschreibung Nomen',
    wrong: 'Ich habe eine frage.',
    correct: 'Ich habe eine Frage.',
    rule: 'Alle Nomen im Deutschen großschreiben',
  ),
  CommonMistake(
    category: 'Verbkonjugation',
    wrong: 'Sie hat mir gesagt, dass er kommen werden.',
    correct: 'Sie hat mir gesagt, dass er kommen wird.',
    rule: 'Im Nebensatz mit Modalverb: Infinitiv + konjugiertes Verb am Ende',
  ),
  CommonMistake(
    category: 'Perfekt vs. Präteritum',
    wrong: 'Gestern ich ging ins Kino.',
    correct: 'Gestern bin ich ins Kino gegangen.',
    rule: 'Im Schreiben B1: Perfekt für Vergangenheit (außer sein/haben/Modalverben)',
  ),
  CommonMistake(
    category: 'Doppeltes Subjekt',
    wrong: 'Meine Mutter, sie kommt morgen.',
    correct: 'Meine Mutter kommt morgen.',
    rule: 'Subjekt nicht doppelt nennen (Nomen + Pronomen)',
  ),
  CommonMistake(
    category: 'Satzklammer',
    wrong: 'Ich habe viele Fotos gemacht von dem Ausflug.',
    correct: 'Ich habe viele Fotos von dem Ausflug gemacht.',
    rule: 'Satzklammer: Partizip/Infinitiv steht ganz am Ende',
  ),
];

/// Quick verb+Kasus reference table on the cheatsheet's mistakes page.
const List<(String verb, String kasus, String beispiel)> kVerbKasusReference = [
  ('helfen', 'Dativ', 'Ich helfe ihr.'),
  ('danken', 'Dativ', 'Ich danke Ihnen.'),
  ('gehören', 'Dativ', 'Das gehört mir.'),
  ('besuchen', 'Akkusativ', 'Ich besuche ihn.'),
  ('fragen', 'Akkusativ', 'Ich frage sie.'),
  ('warten auf', 'Akkusativ', 'Ich warte auf dich.'),
];
