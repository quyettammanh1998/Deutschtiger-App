import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../ai_tutor_provider.dart';
import '../../domain/ai_tutor_models.dart';

class AIModeSelector extends ConsumerWidget {
  const AIModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modesAsync = ref.watch(aiTutorModesProvider);

    return modesAsync.when(
      loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
      error: (e, _) => SizedBox(height: 80, child: Center(child: Text('Error: $e'))),
      data: (modes) => Container(
        height: 80,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: modes.length,
          itemBuilder: (context, index) => _ModeCard(mode: modes[index]),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final AITutorMode mode;

  const _ModeCard({required this.mode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getModeIcon(mode.avatar), color: AppColors.primary),
          const SizedBox(height: 4),
          Text(
            mode.nameVi,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  IconData _getModeIcon(String avatar) {
    switch (avatar) {
      case 'teacher':
        return Icons.school;
      case 'friend':
        return Icons.chat;
      case 'books':
        return Icons.library_books;
      case 'editor':
        return Icons.edit_note;
      default:
        return Icons.smart_toy;
    }
  }
}
