import 'package:deutschtiger/screens/interview/interview_roadmap_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows premium gate when the premium flag is off (default)', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: InterviewRoadmapScreen())),
    );
    await tester.pumpAndSettle();

    // ReleaseFeatureFlags.premium defaults to false — page-level PurchaseGate
    // parity means the roadmap never fetches the learning path when off.
    expect(find.text('Luyện phỏng vấn'), findsWidgets);
    expect(find.textContaining('tính năng premium chưa mở trên app'), findsOneWidget);
  });
}
