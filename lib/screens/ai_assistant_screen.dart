import 'package:flutter/material.dart';
import '../services/AI/ai_services.dart';
import '../services/database_service.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final AIService _aiService = AIService();
  Map<String, dynamic>? userProfile;

  final List<Map<String, String>> messages = [];

  bool isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> sendQuestion() async {
    final question = _controller.text.trim();

    if (question.isEmpty || isLoading) {
      return;
    }

    setState(() {
      messages.add({
        'sender': 'user',
        'message': question,
      });

      isLoading = true;
    });

    _controller.clear();

    try {
      final response = await _aiService.getChatResponse(
        question: question,
        userProfile: userProfile,
      );

      if (!mounted) return;

      setState(() {
        messages.add({
          'sender': 'ai',
          'message': response,
        });

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        messages.add({
          'sender': 'ai',
          'message':
              'Sorry, I could not connect to Stryve AI right now.',
        });

        isLoading = false;
      });

      print('AI ERROR: $e');
    }
  }

  Future<void> loadUserProfile() async {
  final user = await DatabaseService.getUser();

  if (!mounted) return;

  setState(() {
    userProfile = user;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stryve AI'),
      ),

      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(
                    child: Text(
                      'Ask Stryve AI about fitness, exercise, '
                      'nutrition, recovery, or progress.',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];

                      final bool isUser =
                          message['sender'] == 'user';

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          padding: const EdgeInsets.all(12),
                          constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width *
                                    0.80,
                          ),
                          decoration: BoxDecoration(
                            color: isUser
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                : Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                          child: Text(
                            message['message'] ?? '',
                            style: TextStyle(
                              color: isUser
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurface,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 8,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Stryve AI is thinking...',
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) {
                      sendQuestion();
                    },
                    decoration: const InputDecoration(
                      hintText: 'Ask Stryve AI...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  onPressed:
                      isLoading ? null : sendQuestion,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}