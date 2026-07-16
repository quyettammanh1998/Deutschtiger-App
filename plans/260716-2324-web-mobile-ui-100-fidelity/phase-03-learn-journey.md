# Phase 03 — Learn & journey

Scout: `scout-260716-2324-ui-fidelity-learn-vocab-practice-report.md` (phần learn).

## Màn & verdict

| Web | Flutter target | Việc |
|---|---|---|
| `learn/learn-home-page.tsx` (`/learn`) | `lib/screens/journey/journey_screen.dart` + widgets | Rebuild: PageIntro, dải A1→C2, weekly missions, capability-map card; session card 4-stage grid; bỏ AppBar/tiles thừa |
| `learn/mission-session-page.tsx` + `mission-session-runner.tsx` | `lib/features/mission/presentation/mission_session_page.dart` | Rebuild engine: multi-game rounds theo web (không flip-card tự chế), ResumePreStep, MissionCompleteOverlay trophy/XP. Route `/learn/session/:id` (redirect từ `/journey/session`). Đã chốt: rebuild theo web |
| `learn/can-do-practice-page.tsx` | `lib/screens/learn/can_do_practice_screen.dart` | Back-link thay AppBar, CTA gradient cam, done/all-clear views có card + CTA |
| `learn/topic-explore-page.tsx` | `lib/screens/learn/topic_explore_screen.dart` | Thêm card steering "Lộ trình đang ưu tiên" gradient; card icon-gradient + ⭐ pin thay ExpansionTile/Chips |
| `learn/focus-session-page.tsx` (`/focus`) | `lib/screens/learn/focus_session_screen.dart` | GoalReasonLine, 2 empty states, link "Xem lỗi hay gặp"; sửa 2 CTA route sai |
| `learn/learner-model-page.tsx` | `lib/screens/learn/learner_model_screen.dart` | Thêm readiness card, learning-depth card, weekly recap, PageIntro; can-do card status tints + gradient CTA; đúng block order. Gỡ comment "không cần parity pixel" |

## Ghi chú

- Mission runner tái dùng các game view của practice (P4) — điều phối: P3 dựng
  engine + placeholder round adapter, hoàn thiện round types khi P4 xong (hoặc
  chạy P4 trước P3-runner).
- `/learn/group` video browser (Flutter-only): XÓA (không có trên web).

## Validation

- `flutter analyze`; test learn/journey hiện có pass (sửa thay vì weaken).
- Screenshot: /learn, session runner, learner-model so web.

## Risks

- Rebuild mission runner đổi hành vi học — đã chốt 16/07: làm theo web; flag
  `journey` hiện có chỉ giữ gate tới khi engine mới pass test.
