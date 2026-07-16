# Phase 09 — Writing ecosystem (Schreiben / luyện-viết)

Scout: `scout-260716-2324-ui-fidelity-exam-writing-report.md`. 15/16 màn MISSING —
đây là mảng thiếu lớn nhất. **Supersede (v2):** phase này SỞ HỮU UI Schreiben,
thay scope UI của GĐ2 P2 (`260715-flutter-gd2-extended-coverage/phase-02`);
kiến trúc data GĐ2 P2 (drafts/GradeJob/quota) giữ nguyên làm nền — đọc phase
đó trước khi code. Web vừa "unify luyện-viết navigation + retire sprint v1"
(commit `85aadef`) — chỉ port routes live trong `src/app/routes.tsx` hiện tại.

## Thứ tự build (theo report)

**Chạy 4 wave BẮT BUỘC (v2 — 17 màn không đi 1 pass):**
W1 = mục 1+2a-b (panel + hub + teil-pick), W2 = 2c-f (topic list, detail,
practice, community list), W3 = mục 3 (luyện-viết generic 6 màn),
W4 = mục 4+5 (sprint + telc). Mỗi wave analyze+test xong mới sang wave sau.

1. **WritingPracticePanel dùng chung** (web
   `src/components/writing/writing-practice-panel.tsx` — sửa path sai ở v1):
   draft autosave, umlaut bar + diff view (từ P1 primitives), AI grade card
   (bands/corrections/suggestions), rewrite diff. Đặt `lib/features/writing/`.
2. Goethe B1 suite:
   - `goethe-b1-hub-page` → sửa `goethe_b1_hub_page.dart`: readiness card + 1 card
     3 hàng VN (official/writing/sprechen) — bỏ mock English 4 sections.
   - `goethe-b1-writing-teil-pick` (`/exams/goethe-b1/writing`): hero cam/amber,
     badge pills, stat mini-cards, TeilPickCards progress bars.
   - `goethe-b1-writing-topic-list` (`.../writing/:teilNum`): search, Sprint 10h
     pill, community folder card, topic rows (star/difficulty/HOT/Premium),
     leaderboard, free-limit banner.
   - `goethe-b1-writing-detail` (`.../:teilNum/:slug`): reader emoji collapsible
     sections, floating TOC pill, font-scale, premium lock, complete CTA.
     **Spec đầy đủ 30+ component ĐÃ CÓ (17/07):**
     `plans/reports/scout-260717-0014-goethe-b1-writing-detail-components-spec-report.md`
     — implementer đọc spec đó thay vì tự trace. Điểm dễ sai (từ spec):
     autoplay control nằm inline header khi idle, chỉ fixed TOP-right khi đang
     phát (không phải FAB); TOC order ≠ DOM order (Lỗi trước Từ vựng trong TOC);
     TextStructure không có TOC entry + không bị autoplay force-open; cả trang
     chỉ dùng 3 phosphor icon (SpeakerHigh/Pause/Lock), còn lại inline SVG +
     emoji; uebungen 5 loại bài (cloze/word-order/match local, error-correction
     + mini-write chấm AI batch + idle prefetch 1.5s, sessionStorage persist);
     typing-practice suite fullscreen (picker→masked runner→completion, resume);
     free tier 5 topic/Teil + `isOfficialLocked` server-enforced (lock copy riêng);
     "🌐 Dịch ví dụ" gọi Google Translate từ client (mobile: cân nhắc route qua
     backend translate có sẵn — ghi deviation nếu đổi).
   - `goethe-b1-writing-practice`: wrapper WritingPracticePanel.
   - `goethe-b1-community-writing-list`: community topic cards + contributor/vote.
3. Luyện-viết generic:
   - `writing-catalog` (`/luyen-viet`): 3 tab (Bắt đầu/Bài của tôi/Cộng đồng),
     rubric sheet, criteria trend, filter bar, submission list.
   - `writing-level-topics`, `writing-level-practice`, `writing-community-topic`
     (version selector, create wizard, comments), `writing-custom` (`/luyen-viet/tu-nhap`:
     chip selectors, 2 textarea, ✨ AI-polish, 2-phase flow), `writing-session-detail`
     (`/writing-practice/:id`: read-only + Luyện lại + grading timeline).
4. Sprint v2: `exam-writing-sprint` (SR mode picker Marathon/Daily, resume CTA),
   `-session` (sticky progress, SR flashcard + rating bar), `-mock` (dot progress,
   EssayInput 50–120 từ, MockResultCard), **`-cheatsheet` (Redemittel — LIVE tại
   routes.tsx:521, v1 bỏ sót; mode-picker link tới nó)**. Persistence — ĐÃ XÁC
   MINH 17/07: web lưu SM-2 `due` = ISO timestamp TUYỆT ĐỐI qua localStorage
   (sm2-scheduler.ts:22-47; Marathon cap `sessionStart+10h`) → Flutter lưu
   Hive/prefs cùng absolute timestamps là restart-safe, không cần timer nền.
   ⚠ Rủi ro mới phát hiện: sprint steps `cluster-mindmap`/`global-mindmap`
   render bằng **markmap-lib + mermaid** (dynamic import) — Flutter không có
   tương đương; phương án: render qua WebView (app đã có webview feature) hoặc
   custom tree widget — chốt khi implement W4, ghi deviation nếu chọn custom.
5. `schreiben-view` (telc legacy): hội tụ vào WritingPracticePanel thay vì port
   nguyên trạng (unresolved #1 — đề xuất hội tụ; giữ route + redirect).

## Xóa

- `lib/screens/ai/ai_writing_practice_page.dart` + `goethe_b1_writing_page.dart`
  (mock) + `lib/screens/exam/widgets/writing_topics_list.dart` (orphan) sau khi
  màn mới live.

## Data

- Contract mới dùng phải probe backend (`thamkhao/deutschtiger-backend` handlers
  schreiben/writing) + ghi `docs/flutter-api-contract-matrix.md` + `docs/api-changelog.md`.
- AI grading SSE tái dùng SSE client PARITY P1.

## Validation

- Flow: pick teil → topic → detail → practice → grade → session detail.
- Sprint SR queue sống qua restart. analyze + tests + l10n pass.

## Risks

- Premium gating 5-free-topics: hiển thị theo flag premium; CTA IAP chờ MASTER P7.
- Mảng lớn nhất (~16 màn) — có thể tách wave nhỏ khi thi công (hub+teil-pick →
  topic+detail → practice/grade → sprint → community).
