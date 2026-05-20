import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../tutorials/video_player_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(project['title'])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image Placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(project['imageIcon'],
                  size: 100, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 24),

            // Required Components Section
            Text('Required Components',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (project['components'] as List).map((comp) {
                return Chip(
                  label: Text(comp),
                  backgroundColor: AppTheme.surfaceColor,
                  side: const BorderSide(color: AppTheme.primaryColor),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Step-by-Step Implementation
            Text('Implementation Steps',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const ListTile(
              leading: CircleAvatar(child: Text('1')),
              title: Text('Connect components according to circuit diagram.'),
            ),
            const ListTile(
              leading: CircleAvatar(child: Text('2')),
              title: Text('Upload the provided source code to your board.'),
            ),
            const ListTile(
              leading: CircleAvatar(child: Text('3')),
              title: Text('Test and debug the system.'),
            ),
            const SizedBox(height: 24),

            // Source Code Section
            Text('Source Code', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'void setup() {\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  // Code logic here\n}',
                style: TextStyle(
                    fontFamily: 'monospace', color: Colors.greenAccent),
              ),
            ),
            const SizedBox(height: 24),

            // Video Tutorial Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerScreen(
                      videoId: 'dQw4w9WgXcQ', // Placeholder ID
                      title: '${project['title']} Tutorial',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.play_circle_fill),
              label: const Text('Watch Video Tutorial'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
