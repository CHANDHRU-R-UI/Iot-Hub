import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'dart:async';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timeLeft = 30;
  Timer? _timer;
  bool _answered = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Which microcontroller is used in Arduino Uno?',
      'options': ['ATmega328P', 'ESP32', 'ARM Cortex', 'PIC16F'],
      'answer': 0,
    },
    {
      'question': 'What does IoT stand for?',
      'options': [
        'Internet of Technology',
        'Internal of Things',
        'Internet of Things',
        'Internet of Time'
      ],
      'answer': 2,
    },
    {
      'question': 'Which protocol is lightweight and ideal for IoT?',
      'options': ['HTTP', 'MQTT', 'FTP', 'SMTP'],
      'answer': 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
        _nextQuestion();
      }
    });
  }

  void _checkAnswer(int selectedIndex) {
    if (_answered) return;

    setState(() {
      _answered = true;
      if (selectedIndex == _questions[_currentQuestionIndex]['answer']) {
        _score += 10;
      }
    });

    _timer?.cancel();

    Future.delayed(const Duration(seconds: 2), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answered = false;
      });
      _startTimer();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              QuizResultScreen(score: _score, total: _questions.length * 10),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('IoT Quiz'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '00:$_timeLeft',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _timeLeft <= 10
                      ? AppTheme.secondaryColor
                      : AppTheme.primaryColor,
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} / ${_questions.length}',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: AppTheme.accentColor),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                currentQ['question'],
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ...List.generate(4, (index) {
              Color btnColor = AppTheme.surfaceColor;
              if (_answered) {
                if (index == currentQ['answer']) {
                  btnColor = Colors.green.withValues(alpha: 0.8);
                } else {
                  btnColor = Colors.red.withValues(alpha: 0.8);
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor,
                    foregroundColor: AppTheme.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                          color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                    ),
                  ),
                  onPressed: () => _checkAnswer(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      currentQ['options'][index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
