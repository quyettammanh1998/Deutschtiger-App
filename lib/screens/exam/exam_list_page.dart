import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../features/exam/presentation/exam_player_provider.dart';
import '../../features/exam/presentation/widgets/exam_catalog_list.dart';
import '../../widgets/common/async_state_views.dart';

class ExamListPage extends ConsumerWidget {
  const ExamListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(examCatalogProvider);
    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(title: const Text('Đề thi Goethe B1')),
      body: catalog.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(examCatalogProvider),
        ),
        data: (items) => ExamCatalogList(
          items: items
              .where((item) => item.provider == 'goethe' && item.level == 'B1')
              .toList(),
        ),
      ),
    );
  }
}
