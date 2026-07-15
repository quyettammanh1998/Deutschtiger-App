// ignore_for_file: prefer_initializing_formals
//
// Sample exam fixture cho GĐ1 — dùng khi BE chưa sẵn sàng hoặc dev mode.
//
// Telc B1 demo: 6 câu Lesen (MC + matching + richtig/falsch + sprachbausteine
// + anzeigen) + 6 câu Hören (cùng 5 type, có audioUrl trỏ tới file mẫu).
//
// BE thật (deutschtiger-backend `/api/v1/exams/{id}`) sẽ trả shape giống
// [Exam.fromJson].

import '../domain/exam_models.dart';

/// Trả về một telc B1 demo để player dùng khi chưa có BE.
Exam sampleTelcB1Exam() => const Exam(
      id: 'telc-b1-demo-01',
      title: 'telc Deutsch B1 · Demo',
      level: 'b1',
      provider: 'telc',
      description: 'Bài thi mẫu telc B1 — Lesen + Hören',
      sections: [
        ExamSection(
          kind: ExamSectionKind.lesen,
          durationMinutes: 25,
          questions: [
            ExamQuestion(
              id: 'lesen-1',
              type: QuestionType.mc,
              prompt:
                  'Lesen Sie den Text und beantworten Sie die Frage.\n\n'
                  'Maria arbeitet seit drei Jahren bei einer Firma in Berlin. '
                  'Sie ist zufrieden, möchte aber mehr Verantwortung.',
              options: [
                ExamOption(id: 'a', text: 'Maria ist seit fünf Jahren bei der Firma.'),
                ExamOption(id: 'b', text: 'Maria ist zufrieden mit ihrer Arbeit.'),
                ExamOption(id: 'c', text: 'Maria hat keine Beförderung bekommen.'),
                ExamOption(id: 'd', text: 'Maria arbeitet in Hamburg.'),
              ],
              correctOptionId: 'b',
              explanation: 'Im Text steht "Sie ist zufrieden".',
            ),
            ExamQuestion(
              id: 'lesen-2',
              type: QuestionType.matching,
              prompt: 'Ordnen Sie zu: Welche Antwort passt zu welcher Situation?',
              matchLeft: [
                'Entschuldigung, ich komme zu spät.',
                'Ich möchte mich beschweren.',
                'Können Sie mir helfen?',
              ],
              matchRight: [
                'Das macht doch nichts.',
                'Oh, das tut mir leid. Was kann ich tun?',
                'Aber natürlich! Worum geht es?',
              ],
              correctMatches: {0: 0, 1: 1, 2: 2},
              explanation: 'Höfliche Reaktionen passen zur jeweiligen Situation.',
            ),
            ExamQuestion(
              id: 'lesen-3',
              type: QuestionType.richtigFalsch,
              prompt:
                  'Lesen Sie die Aussage und entscheiden Sie: richtig oder falsch?\n\n'
                  '"Im Supermarkt kann man nur mit Karte bezahlen."',
              correctBoolean: false,
              explanation: 'Man kann auch bar bezahlen.',
            ),
            ExamQuestion(
              id: 'lesen-4',
              type: QuestionType.sprachbausteine,
              prompt:
                  'Ergänzen Sie den Text: "Ich ___ seit zwei Jahren in Deutschland ___."',
              options: [
                ExamOption(id: 'a', text: 'lebe'),
                ExamOption(id: 'b', text: 'wohne'),
                ExamOption(id: 'c', text: 'arbeite'),
                ExamOption(id: 'd', text: 'lerne'),
                ExamOption(id: 'e', text: 'seit'),
                ExamOption(id: 'f', text: 'für'),
                ExamOption(id: 'g', text: 'mit'),
                ExamOption(id: 'h', text: 'und'),
              ],
              gapPositions: [1, 3],
              // Index của các option đúng theo thứ tự gap.
              explanation: 'Perfekt: "Ich wohne seit zwei Jahren in Deutschland."',
            ),
            ExamQuestion(
              id: 'lesen-5',
              type: QuestionType.anzeigen,
              prompt: 'Welche Anzeige passt? "Sie suchen einen Babysitter für 2 Kinder."',
              options: [
                ExamOption(id: 'a', text: 'Familie mit 2 Kindern sucht Babysitter.'),
                ExamOption(id: 'b', text: 'Restaurant sucht Koch.'),
                ExamOption(id: 'c', text: 'Tischler bietet Möbelreparatur.'),
                ExamOption(id: 'd', text: 'Sprachschule sucht Lehrer.'),
              ],
              correctOptionId: 'a',
              explanation: 'Nur Anzeige A passt zur Aussage.',
            ),
            ExamQuestion(
              id: 'lesen-6',
              type: QuestionType.mc,
              prompt: 'Wählen Sie die richtige Antwort.',
              options: [
                ExamOption(id: 'a', text: 'Das Wetter ist schön.'),
                ExamOption(id: 'b', text: 'Das Wetter ist schlecht.'),
                ExamOption(id: 'c', text: 'Das Wetter ist kalt.'),
                ExamOption(id: 'd', text: 'Das Wetter ist warm.'),
              ],
              correctOptionId: 'a',
            ),
          ],
        ),
        ExamSection(
          kind: ExamSectionKind.hoeren,
          durationMinutes: 40,
          audioIntroUrl: 'https://example.com/audio/hoeren-intro.mp3',
          questions: [
            ExamQuestion(
              id: 'hoeren-1',
              type: QuestionType.mc,
              prompt: 'Hören Sie die Durchsage am Bahnhof. Was ist richtig?',
              audioUrl: 'https://example.com/audio/hoeren-1.mp3',
              audioMaxPlays: 2,
              options: [
                ExamOption(id: 'a', text: 'Der Zug hat 10 Minuten Verspätung.'),
                ExamOption(id: 'b', text: 'Der Zug kommt pünktlich.'),
                ExamOption(id: 'c', text: 'Der Zug fällt aus.'),
                ExamOption(id: 'd', text: 'Der Zug hat 5 Minuten Verspätung.'),
              ],
              correctOptionId: 'a',
              explanation: 'Die Durchsage sagt "10 Minuten Verspätung".',
            ),
            ExamQuestion(
              id: 'hoeren-2',
              type: QuestionType.richtigFalsch,
              prompt: 'Hören Sie das Gespräch. Ist Frau Schmidt verheiratet?',
              audioUrl: 'https://example.com/audio/hoeren-2.mp3',
              audioMaxPlays: 2,
              correctBoolean: true,
            ),
            ExamQuestion(
              id: 'hoeren-3',
              type: QuestionType.matching,
              prompt: 'Hören Sie die Ansagen. Ordnen Sie zu.',
              audioUrl: 'https://example.com/audio/hoeren-3.mp3',
              audioMaxPlays: 2,
              matchLeft: ['Bahnhof', 'Flughafen', 'Supermarkt'],
              matchRight: [
                'Gleis 3',
                'Gate 12',
                'Kasse 2',
              ],
              correctMatches: {0: 0, 1: 1, 2: 2},
            ),
            ExamQuestion(
              id: 'hoeren-4',
              type: QuestionType.sprachbausteine,
              prompt: 'Ergänzen Sie: "Ich ___ morgen nach Berlin ___."',
              audioUrl: 'https://example.com/audio/hoeren-4.mp3',
              audioMaxPlays: 2,
              options: [
                ExamOption(id: 'a', text: 'fahre'),
                ExamOption(id: 'b', text: 'gehe'),
                ExamOption(id: 'c', text: 'morgen'),
                ExamOption(id: 'd', text: 'heute'),
                ExamOption(id: 'e', text: 'nach'),
                ExamOption(id: 'f', text: 'in'),
              ],
              gapPositions: [0, 2],
              explanation: '"Ich fahre morgen nach Berlin."',
            ),
            ExamQuestion(
              id: 'hoeren-5',
              type: QuestionType.anzeigen,
              prompt: 'Welche Anzeige passt zur gehörten Aussage?',
              audioUrl: 'https://example.com/audio/hoeren-5.mp3',
              audioMaxPlays: 2,
              options: [
                ExamOption(id: 'a', text: 'Wohnung zu vermieten.'),
                ExamOption(id: 'b', text: 'Auto zu verkaufen.'),
                ExamOption(id: 'c', text: 'Stelle als Kellner.'),
                ExamOption(id: 'd', text: 'Sprachkurs.'),
              ],
              correctOptionId: 'a',
            ),
            ExamQuestion(
              id: 'hoeren-6',
              type: QuestionType.mc,
              prompt: 'Was hat der Sprecher gesagt?',
              audioUrl: 'https://example.com/audio/hoeren-6.mp3',
              audioMaxPlays: 2,
              options: [
                ExamOption(id: 'a', text: 'Er kommt um 8 Uhr.'),
                ExamOption(id: 'b', text: 'Er kommt um 9 Uhr.'),
                ExamOption(id: 'c', text: 'Er kommt um 10 Uhr.'),
                ExamOption(id: 'd', text: 'Er kommt später.'),
              ],
              correctOptionId: 'b',
            ),
          ],
        ),
      ],
    );