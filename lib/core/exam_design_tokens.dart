import 'package:flutter/material.dart';

/// Exam-scoped design tokens extracted from
/// `thamkhao/deutschtiger-frontend/src/styles/exam-tokens.css` (Phase 2).
///
/// Tách riêng khỏi `DesignTokens` để:
///   - Không override global `--primary` (giữ nguyên dashboard/sidebar/brand pages).
///   - Exam UI có palette blue/emerald/red/yellow riêng, độ tương phản cao hơn.
///   - Dễ dark-mode-scope: dark variant giữ WCAG AA trên white text.
///
/// Dùng trong module `lib/features/exam/` thông qua các const bên dưới.
class ExamDesignTokens {
  const ExamDesignTokens._();

  // ===== Light Theme =====
  // Source: web :root — exam-tokens.css (blue-600 active, emerald/red/yellow badges).
  static const Color examActive = Color(0xFF2563EB);         // hsl(217, 91%, 60%) blue-600
  static const Color examActiveSoft = Color(0xFFEBF3FF);     // hsl(214, 95%, 95%) blue-50
  static const Color examActiveFg = Color(0xFFFFFFFF);       // white
  static const Color examActiveStrong = Color(0xFF1D4ED8);   // hsl(221, 83%, 53%) blue-700

  // Highlight (user mark in exam reading) — tím dịu, khác blue active.
  // Source: web highlight-paint.ts (color-mix in srgb) → ~hsl(260, 60%, 70%).
  static const Color examHighlightColor = Color(0xFFB794F4); // violet-300

  // Paper / reading bg — tone giấy nhạt, dịu mắt khi đọc dài.
  // Source: web exam-markdown bg = --card (white) + 2% warm overlay.
  static const Color examPaperColor = Color(0xFFFFFCF7);     // warm white

  static const Color examSuccess = Color(0xFF10B981);        // hsl(160, 84%, 39%) emerald-600
  static const Color examAnswerCorrectColor = examSuccess;
  static const Color examSuccessSoft = Color(0xFFECFDF5);    // hsl(152, 81%, 96%) emerald-50
  static const Color examSuccessFg = Color(0xFF047857);      // hsl(160, 84%, 25%)
  static const Color examSuccessBorder = Color(0xFF6EE7B7);  // hsl(156, 72%, 67%) emerald-300

  static const Color examDanger = Color(0xFFDC2626);         // hsl(0, 72%, 51%) red-600
  static const Color examAnswerWrongColor = examDanger;
  static const Color examDangerSoft = Color(0xFFFEF2F2);     // hsl(0, 86%, 97%) red-50
  static const Color examDangerFg = Color(0xFFB91C1C);       // hsl(0, 70%, 35%)
  static const Color examDangerBorder = Color(0xFFFCA5A5);   // hsl(0, 94%, 82%) red-300

  static const Color examWarnSoft = Color(0xFFFEFCE8);       // hsl(48, 96%, 95%) yellow-50 — gap fields
  static const Color examWarnBorder = Color(0xFFFACC15);     // hsl(45, 93%, 65%) yellow-400 dashed
  static const Color examWarnFg = Color(0xFFB45309);         // hsl(35, 91%, 33%) amber-700

  // Timer — đỏ cam nổi bật để cảnh báo hết giờ.
  // Source: web TimerBar countdown, 60s cuối chuyển sang hue này.
  static const Color examTimerColor = Color(0xFFEA580C);     // orange-600

  // Text — darker than global foreground cho readability nội dung tiếng Đức dài.
  static const Color examTextPrimary = Color(0xFF1A1A1A);    // hsl(0, 0%, 10%)
  static const Color examTextSecondary = Color(0xFF5A6270);  // hsl(220, 9%, 38%) — Vietnamese UI
  static const Color examTextTertiary = Color(0xFF838D9A);   // hsl(220, 9%, 55%) — metadata

  static const Color examBorder = Color(0xFFE5E7EB);         // hsl(220, 13%, 91%)
  static const Color examBorderActive = examActive;

  // ===== Dark Theme =====
  // Source: web `.dark` exam-tokens.css — active stays 55% L cho white-text WCAG AA.
  static const Color darkExamActive = Color(0xFF2563EB);     // hsl(217, 91%, 55%)
  static const Color darkExamActiveSoft = Color(0xFF0E1F3A); // hsl(217, 91%, 14%)
  static const Color darkExamActiveFg = Color(0xFFFFFFFF);
  static const Color darkExamActiveStrong = Color(0xFF93C5FD); // hsl(213, 94%, 78%) blue-300

  static const Color darkExamSuccess = Color(0xFF0F9F76);    // hsl(160, 70%, 38%)
  static const Color darkExamSuccessSoft = Color(0xFF06281F);
  static const Color darkExamSuccessFg = Color(0xFF6EE7B7);
  static const Color darkExamSuccessBorder = Color(0xFF0F8A66);

  static const Color darkExamDanger = Color(0xFFD03A3A);     // hsl(0, 72%, 48%)
  static const Color darkExamDangerSoft = Color(0xFF2C0A0A);
  static const Color darkExamDangerFg = Color(0xFFFCA5A5);
  static const Color darkExamDangerBorder = Color(0xFFA02929);

  static const Color darkExamWarnSoft = Color(0xFF2A2410);
  static const Color darkExamWarnBorder = Color(0xFFEAB308);
  static const Color darkExamWarnFg = Color(0xFFFDE68A);

  static const Color darkExamTextPrimary = Color(0xFFFAFAFA);
  static const Color darkExamTextSecondary = Color(0xFFCAD0D8); // hsl(220, 9%, 80%)
  static const Color darkExamTextTertiary = Color(0xFFA6AEB8);

  static const Color darkExamBorder = Color(0xFF3A4151);     // hsl(220, 13%, 24%)

  // ===== Layout =====
  // Source: web mobile exam player padding — p-4 outer, p-3 inner cards.
  static const double examPadding = 16;
  static const double examCardPadding = 12;
  static const double examSectionGap = 16;
  static const double examQuestionGap = 12;

  // ===== Animation =====
  // Source: web `.exam-fade` 200ms ease-out (index.css exam-fade-in keyframe).
  static const Duration examFadeDuration = Duration(milliseconds: 200);
}
