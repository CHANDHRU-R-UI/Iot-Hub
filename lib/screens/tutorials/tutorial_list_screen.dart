import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'video_player_screen.dart';

class TutorialListScreen extends StatelessWidget {
  const TutorialListScreen({super.key});

  final List<Map<String, dynamic>> _tutorials = const [
    {
      'title': 'Arduino Basics for Beginners',
      'duration': '15:20',
      'videoId': 'zJ-LqeX_fLU', // Placeholder
      'icon': Icons.play_circle_outline,
    },
    {
      'title': 'ESP32 Wi-Fi Setup',
      'duration': '12:45',
      'videoId': 'dQw4w9WgXcQ', // Placeholder
      'icon': Icons.wifi_tethering,
    },
    {
      'title': 'Home Automation with IoT',
      'duration': '25:10',
      'videoId': 'zJ-LqeX_fLU', // Placeholder
      'icon': Icons.home,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Tutorials')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tutorials.length,
        itemBuilder: (context, index) {
          final tutorial = _tutorials[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(tutorial['icon'], color: AppTheme.primaryColor),
              ),
              title: Text(
                tutorial['title'],
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
              ),
              subtitle: Text('Duration: ${tutorial['duration']}'),
              trailing: const Icon(Icons.play_arrow, color: AppTheme.accentColor),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerScreen(
                      videoId: tutorial['videoId'],
                      title: tutorial['title'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
