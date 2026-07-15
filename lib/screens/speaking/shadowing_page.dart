import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/data/speaking/speaking_models.dart';
import 'package:deutschtiger/repositories/speaking/speaking_repository.dart';
import 'package:deutschtiger/widgets/speaking/pronunciation_practice_widget.dart';

class ShadowingPage extends ConsumerStatefulWidget {
  const ShadowingPage({super.key});

  @override
  ConsumerState<ShadowingPage> createState() => _ShadowingPageState();
}

class _ShadowingPageState extends ConsumerState<ShadowingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final List<SpeakingSession> _sessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final repo = SpeakingRepository();
    final sessions = await repo.getShadowingSessions();
    if (mounted) {
      setState(() => _sessions.addAll(sessions));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Shadowing Practice'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.foreground,
      ),
      body: _sessions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildProgressIndicator(),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentIndex = index),
                    itemCount: _sessions.length,
                    itemBuilder: (context, index) => _buildSessionCard(_sessions[index]),
                  ),
                ),
                _buildBottomControls(),
              ],
            ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(_sessions.length, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index <= _currentIndex ? AppColors.primary : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSessionCard(SpeakingSession session) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            session.titleVi,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            session.description,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _GermanSentenceCard(
            transcript: session.transcript,
            translation: session.translation,
          ),
          const SizedBox(height: 24),
          _WordByWordView(text: session.transcript),
          const SizedBox(height: 32),
          PronunciationPracticeWidget(
            word: session.transcript,
            phonetic: '',
            translation: session.translation,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentIndex > 0)
              IconButton(
                onPressed: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                icon: const Icon(Icons.arrow_back_ios),
                color: AppColors.primary,
              )
            else
              const SizedBox(width: 48),
            Expanded(
              child: Text(
                '${_currentIndex + 1} / ${_sessions.length}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (_currentIndex < _sessions.length - 1)
              ElevatedButton.icon(
                onPressed: () => _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                icon: const Icon(Icons.arrow_forward_ios, size: 18),
                label: const Text('Next'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.check_circle),
                label: const Text('Complete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GermanSentenceCard extends StatelessWidget {
  final String transcript;
  final String translation;

  const _GermanSentenceCard({required this.transcript, required this.translation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.tigerOrange.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            transcript,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.foreground,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            width: 60,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            translation,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _WordByWordView extends StatefulWidget {
  final String text;

  const _WordByWordView({required this.text});

  @override
  State<_WordByWordView> createState() => _WordByWordViewState();
}

class _WordByWordViewState extends State<_WordByWordView> {
  int _currentWordIndex = 0;
  final List<String> _words = [];

  @override
  void initState() {
    super.initState();
    _words.addAll(widget.text.split(' '));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.format_list_numbered, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Word by Word',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
              ),
              const Spacer(),
              Text(
                '${_currentWordIndex + 1}/${_words.length}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_words.length, (index) {
              final isActive = index == _currentWordIndex;
              final isCompleted = index < _currentWordIndex;
              return GestureDetector(
                onTap: () => setState(() => _currentWordIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : isCompleted
                            ? AppColors.success.withValues(alpha: 0.2)
                            : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: isActive
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
                  ),
                  child: Text(
                    _words[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive
                          ? Colors.white
                          : isCompleted
                              ? AppColors.success
                              : AppColors.foreground,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                onPressed: _currentWordIndex > 0
                    ? () => setState(() => _currentWordIndex--)
                    : null,
                icon: const Icon(Icons.skip_previous),
                color: AppColors.primary,
              ),
              IconButton(
                onPressed: _currentWordIndex < _words.length - 1
                    ? () => setState(() => _currentWordIndex++)
                    : null,
                icon: const Icon(Icons.skip_next),
                color: AppColors.primary,
              ),
              const Spacer(),
              if (_currentWordIndex < _words.length)
                Text(
                  'Tap word to highlight',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
