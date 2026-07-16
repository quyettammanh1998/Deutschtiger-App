# Review — Plans & Code (Flutter parity waves)

Ngày: 2026-07-16 · Branch: main · Reviewer: Claude

## Phạm vi

Rà 4 plan active (MASTER port, WAVE close-out, GĐ2 extended, PARITY roadmap) +
docs parity/live-data + code thực tế. Verify bằng quality gates, không chỉ đọc
report.

## Kết quả verify (bằng chứng)

| Gate | Kết quả |
|---|---|
| `flutter analyze` | PASS — 5 info lint (2 deprecation `RadioGroup` ở `de_thi_practice_screen.dart:174/176`, 3 `prefer_initializing_formals` trong test). Không có warning/error. |
| `flutter test` (full) | PASS — 550/550. Noise 500/`MissingPluginException` là test error-path + plugin headless, không phải fail. |
| `git status` | Sạch, mọi thứ đã commit tới `53561c5`. |
| Quy mô | 486 file dart / ~108k LOC / 148 file test. |

## Đánh giá plans

**Tốt — trung thực, bám evidence.** Plans + docs khớp code thật:

- **Contract-first thực thi đúng**: `ai_repository.dart` gọi 100% endpoint thật
  (`/ai/chat` SSE, `/ai/sessions`, `/ai/memory`, `/ai/profile`), không fallback
  mock. Claim "LIVE" trong parity matrix có căn cứ.
- **Concern được đóng, không bỏ quên**: report AI (DONE_WITH_CONCERNS) nêu 2
  follow-up — (a) `ai_chat_page.dart` chưa vào whitelist guard, (b) test l10n
  fail do flag `journey`. Cả hai **đã fix** ở wave sau: `ai_chat_page.dart` nay
  ở whitelist (`release_live_data_guard_test.dart:48`), suite 550/550 xanh.
- **Gate release nhất quán**: flag default-off đúng các surface thiếu contract —
  `games` blanket (17 màn mock, nhưng 13 game live được exempt riêng),
  `socialGroups/Challenges/Duels`, `speaking/pronunciation` (voice MASTER P8),
  `affiliate/premium/legacyGoetheB1` (deferred). Khớp "Deferred decisions" của
  owner.
- **Gap ghi rõ, không fake**: image-input AI, DW lesson exercises, deck-scoped
  SRS queue, global practice pool... đều log ở `flutter-live-data-inventory.md`
  thay vì độn data giả.

## Rủi ro / điểm cần lưu ý

1. **Guard live-data là text-scan nông** (`release_live_data_guard_test.dart`):
   chỉ bắt literal `mock/fixture/placeholder` trong source route default-on, và
   whitelist phải cập nhật **thủ công** mỗi khi bật route mới. Một màn dùng data
   giả mà không chứa 3 từ đó sẽ lọt. Tripwire hợp lý nhưng đừng coi là bảo chứng
   tuyệt đối — cần review thủ công khi flip flag mới.
2. **Bằng chứng device/live-backend còn thiếu**: nhiều report ghi "không chạy
   emulator/live backend trong sandbox". Contract/widget test thay thế được phần
   lớn, nhưng SSE streaming, push FCM, IAP vẫn cần smoke test thật trước release
   (đúng như `flutter-fidelity-pipeline.md` liệt kê là gate chưa đóng).
3. **2 deprecation `RadioGroup`** ở `de_thi_practice_screen.dart` — vô hại nay
   nhưng sẽ vỡ khi bump Flutter; nên dọn sớm.
4. **Voice/Sprechen/pronunciation** là chặn lớn nhất còn lại — mọi thứ voice
   (speaking 9 màn, 3 game, exam Sprechen, speak-to-notes) chờ MASTER P8 dựng
   mic-capture pipeline. Chưa có gì trong Flutter. Đây là khối MISSING thật sự
   duy nhất còn đáng kể.

## Không có vấn đề

- Không phát hiện data giả bị bật ra release trái với ghi nhận.
- Không có test bị làm yếu/skip để qua gate.
- Working tree khớp mọi claim trong report.

## Câu hỏi mở

1. Device smoke test (welcome flow + SSE + push) chạy ở đâu — CI có runner
   emulator chưa, hay để manual? Ràng buộc RAM máy (14GB) từng crash emulator
   khi build song song.
2. Voice pipeline (MASTER P8) đã có owner/lịch chưa? Đây là chặn cuối cho ~15
   màn còn MISSING/gated.
