import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/data/speaking/speaking_models.dart';
import 'package:deutschtiger/repositories/speaking/speaking_repository.dart';

class ConversationScenarioPage extends ConsumerStatefulWidget {
  final String conversationId;

  const ConversationScenarioPage({super.key, required this.conversationId});

  @override
  ConsumerState<ConversationScenarioPage> createState() =>
      _ConversationScenarioPageState();
}

class _ConversationScenarioPageState
    extends ConsumerState<ConversationScenarioPage> {
  AIConversation? _conversation;
  AIConversationHistory? _history;
  bool _isLoading = true;
  bool _isRecording = false;
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showVocabPanel = false;
  String _userInput = '';

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  Future<void> _loadConversation() async {
    final repo = SpeakingRepository();
    final conversations = await repo.getAIConversations();
    final conversation = conversations.firstWhere(
      (c) => c.id == widget.conversationId,
      orElse: () => conversations.first,
    );
    final history = await repo.startAIConversation(widget.conversationId);
    if (mounted) {
      setState(() {
        _conversation = conversation;
        _history = history;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_userInput.trim().isEmpty) return;

    setState(() {
      _history = _history?.copyWith(
        messages: [
          ...(_history?.messages ?? []),
          AIMessage(
            id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
            role: 'user',
            content: _userInput,
            translation: 'You said: $_userInput',
          ),
        ],
      );
      _userInput = '';
      _inputController.clear();
    });

    _scrollToBottom();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _history = _history?.copyWith(
            messages: [
              ...(_history?.messages ?? []),
              AIMessage(
                id: 'ai-${DateTime.now().millisecondsSinceEpoch}',
                role: 'assistant',
                content: _getAIResponse(),
                translation: 'AI response',
              ),
            ],
          );
        });
        _scrollToBottom();
      }
    });
  }

  String _getAIResponse() {
    final responses = [
      'Das ist sehr gut! Können Sie das noch einmal wiederholen?',
      'Verstanden! Und wie geht es weiter?',
      'Sehr schön! Haben Sie noch Fragen?',
      'Ja, das ist korrekt. Weiter bitte!',
    ];
    return responses[DateTime.now().second % responses.length];
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleRecording() {
    setState(() => _isRecording = !_isRecording);
    if (_isRecording) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isRecording = false;
            _userInput = 'Ich möchte gerne einen Kaffee, bitte.';
            _inputController.text = _userInput;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_conversation?.titleVi ?? 'Conversation'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.foreground,
        actions: [
          IconButton(
            onPressed: () => setState(() => _showVocabPanel = !_showVocabPanel),
            icon: Icon(
              _showVocabPanel ? Icons.menu_book : Icons.menu_book_outlined,
            ),
            tooltip: 'Vocabulary Panel',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Expanded(flex: 3, child: _buildChatArea()),
                if (_showVocabPanel) ...[
                  Container(width: 1, color: Colors.grey[300]),
                  SizedBox(width: 280, child: _buildVocabPanel()),
                ],
              ],
            ),
    );
  }

  Widget _buildChatArea() {
    return Column(
      children: [
        if (_conversation != null) _buildScenarioHeader(),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _history?.messages.length ?? 0,
            itemBuilder: (context, index) =>
                _buildMessageBubble(_history!.messages[index], index % 2 == 0),
          ),
        ),
        _buildInputArea(),
      ],
    );
  }

  Widget _buildScenarioHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _conversation!.level,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '~${_conversation!.estimatedMinutes} min',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _conversation!.scenarioVi,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(AIMessage message, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isUser)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.smart_toy,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ),
                if (!isUser) const SizedBox(width: 8),
                Text(
                  isUser ? 'You' : 'AI',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isUser ? Colors.white70 : AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              message.content,
              style: TextStyle(
                fontSize: 15,
                color: isUser ? Colors.white : AppColors.foreground,
              ),
            ),
            if (message.translation.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                message.translation,
                style: TextStyle(
                  fontSize: 12,
                  color: isUser ? Colors.white60 : Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
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
            GestureDetector(
              onTap: _toggleRecording,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isRecording
                      ? Colors.red
                      : AppColors.primary.withValues(alpha: 0.1),
                ),
                child: Icon(
                  _isRecording ? Icons.stop : Icons.mic,
                  color: _isRecording ? Colors.white : AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _inputController,
                onChanged: (value) => setState(() => _userInput = value),
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: _isRecording
                      ? 'Recording...'
                      : 'Type your message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVocabPanel() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: const Row(
              children: [
                Icon(Icons.menu_book, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text(
                  'Key Vocabulary',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildVocabItem('Guten Tag', 'Hello', '/ˈɡuːtn̩ taːk/'),
                _buildVocabItem('ich möchte', 'I would like', '/ɪç ˈmœçtə/'),
                _buildVocabItem('bitte', 'please', '/ˈbɪtə/'),
                _buildVocabItem('einen Kaffee', 'a coffee', '/ˈaɪnən ˈkafe/'),
                _buildVocabItem(
                  'danke schön',
                  'thank you very much',
                  '/ˈdaŋkə ʃøːn/',
                ),
                _buildVocabItem('gerne', 'gladly/with pleasure', '/ˈɡɛʁnə/'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVocabItem(String word, String translation, String phonetic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            word,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            translation,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            phonetic,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
