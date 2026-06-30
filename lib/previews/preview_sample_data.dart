import 'package:flutter/material.dart';

import '../core/design_tokens.dart';

/// Sample data for widget previews.
///
/// Use these values to create realistic preview content
/// without depending on real user data.

/// Sample user profile data.
class PreviewUserData {
  PreviewUserData._();

  static const displayName = 'Max Mustermann';
  static const email = 'max@example.com';
  static const avatarUrl = '';
  static const level = 5;
  static const streakDays = 12;
  static const totalXp = 1250;
}

/// Sample deck data.
class PreviewDeckData {
  PreviewDeckData._();

  static const title = 'German Basics';
  static const description = 'Essential vocabulary for beginners';
  static const cardCount = 50;
  static const progress = 0.65;
}

/// Sample achievement data.
class PreviewAchievementData {
  PreviewAchievementData._();

  static const title = 'First Steps';
  static const description = 'Complete your first lesson';
  static const icon = Icons.emoji_events;
  static const isUnlocked = true;
}

/// Sample streak data.
class PreviewStreakData {
  PreviewStreakData._();

  static const currentStreak = 7;
  static const longestStreak = 14;
  static const todayCompleted = false;
}

/// Sample progress data.
class PreviewProgressData {
  PreviewProgressData._();

  static const weeklyGoal = 100;
  static const weeklyProgress = 65;
  static const monthlyXp = 2500;
  static const accuracy = 0.87;
}

/// Creates a preview card with standard styling.
Widget previewCard({
  required Widget child,
  double? width,
}) {
  return Container(
    width: width,
    padding: const EdgeInsets.all(DesignTokens.spacingMd),
    decoration: BoxDecoration(
      color: DesignTokens.card,
      borderRadius: BorderRadius.circular(DesignTokens.radius),
      border: Border.all(color: DesignTokens.border),
    ),
    child: child,
  );
}

/// Creates a preview text with standard body style.
Text previewText(String text) {
  return Text(
    text,
    style: DesignTokens.bodyMedium,
  );
}

/// Creates a preview title with standard title style.
Text previewTitle(String text) {
  return Text(
    text,
    style: DesignTokens.titleMedium,
  );
}
