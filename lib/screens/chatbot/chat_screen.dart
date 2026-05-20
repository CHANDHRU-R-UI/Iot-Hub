import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> _messages = [
    {
      'role': 'bot',
      'text': 'Hello! I am your AI IoT Assistant. How can I help you today?'
    },
  ];

  bool _isTyping = false;

  // The Groq API endpoint and authorization key (using CORS proxy on Web)
  final String _apiUrl = kIsWeb
      ? 'https://corsproxy.io/?https://api.groq.com/openai/v1/chat/completions'
      : 'https://api.groq.com/openai/v1/chat/completions';
  final String _apiKey =
      'YOUR_GROQ_API_KEY'; // Replace with your actual Groq API key

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final userText = _messageController.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': userText});
      _isTyping = true;
    });
    _messageController.clear();
    _scrollToBottom();

    try {
      // Build conversation history for the model context
      final List<Map<String, String>> requestMessages = [
        {
          'role': 'system',
          'content':
              'You are a highly helpful and expert AI assistant specialized in IoT (Internet of Things), microcontrollers (Arduino, ESP32, Raspberry Pi), sensors, actuators, firmware programming (C/C++, Python), and cloud integration (MQTT, HTTP, Firebase). Keep your responses concise, educational, and structured.'
        }
      ];

      // Append recent messages
      for (final msg in _messages.skip(1)) {
        requestMessages.add({
          'role': msg['role'] == 'bot' ? 'assistant' : 'user',
          'content': msg['text']!,
        });
      }

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'llama-3.1-8b-instant',
          'messages': requestMessages,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content']?.toString() ??
            'No response content';

        setState(() {
          _messages.add({'role': 'bot', 'text': reply.trim()});
        });
      } else {
        setState(() {
          _messages.add({
            'role': 'bot',
            'text':
                'Sorry, I encountered an error communicating with the Groq API (Code: ${response.statusCode}).'
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'bot',
          'text':
              'An error occurred while connecting to the AI helper. Please check your internet connection.'
        });
      });
    } finally {
      setState(() {
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isBot = msg['role'] == 'bot';
                return Align(
                  alignment:
                      isBot ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isBot
                          ? AppTheme.surfaceColor
                          : AppTheme.primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12).copyWith(
                        bottomLeft: isBot
                            ? const Radius.circular(0)
                            : const Radius.circular(12),
                        bottomRight: !isBot
                            ? const Radius.circular(0)
                            : const Radius.circular(12),
                      ),
                      border: Border.all(
                        color: isBot
                            ? Colors.transparent
                            : AppTheme.primaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      msg['text']!,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            isBot ? AppTheme.textPrimary : AppTheme.accentColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(12).copyWith(
                      bottomLeft: const Radius.circular(0),
                    ),
                  ),
                  child: const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Ask about IoT...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppTheme.surfaceColor,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    iconSize: 18,
                    icon:
                        const Icon(Icons.send, color: AppTheme.backgroundColor),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
