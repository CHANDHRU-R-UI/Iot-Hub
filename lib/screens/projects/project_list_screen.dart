import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'project_detail_screen.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});

  final List<Map<String, dynamic>> _projects = const [
    {
      'title': 'Smart Home Automation',
      'difficulty': 'Medium',
      'components': ['ESP32', 'Relay Module', 'Jumper Wires'],
      'imageIcon': Icons.home_repair_service,
    },
    {
      'title': 'Line Follower Robot',
      'difficulty': 'Hard',
      'components': ['Arduino Uno', 'IR Sensors', 'Motor Driver', 'Chassis'],
      'imageIcon': Icons.smart_toy,
    },
    {
      'title': 'Weather Station',
      'difficulty': 'Easy',
      'components': ['NodeMCU', 'DHT11 Sensor', 'OLED Display'],
      'imageIcon': Icons.cloud,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mini Projects')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _projects.length,
        itemBuilder: (context, index) {
          final project = _projects[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProjectDetailScreen(project: project),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(project['imageIcon'],
                          size: 40, color: AppTheme.primaryColor),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project['title'],
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: project['difficulty'] == 'Easy'
                                      ? Colors.green.withValues(alpha: 0.2)
                                      : project['difficulty'] == 'Medium'
                                          ? Colors.orange.withValues(alpha: 0.2)
                                          : Colors.red.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  project['difficulty'],
                                  style: TextStyle(
                                    color: project['difficulty'] == 'Easy'
                                        ? Colors.green
                                        : project['difficulty'] == 'Medium'
                                            ? Colors.orange
                                            : Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                  '${project['components'].length} Components'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
