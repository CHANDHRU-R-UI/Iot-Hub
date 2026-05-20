import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ComponentListScreen extends StatelessWidget {
  const ComponentListScreen({super.key});

  final List<Map<String, dynamic>> components = const [
    {
      'name': 'Arduino Uno',
      'description': 'Microcontroller board based on the ATmega328P.',
      'icon': Icons.memory,
      'color': Colors.teal,
    },
    {
      'name': 'ESP32',
      'description': 'Low-cost, low-power system on a chip with Wi-Fi & dual-mode Bluetooth.',
      'icon': Icons.wifi,
      'color': Colors.blueAccent,
    },
    {
      'name': 'Ultrasonic Sensor',
      'description': 'Measures distance by using ultrasonic waves.',
      'icon': Icons.sensors,
      'color': Colors.orangeAccent,
    },
    {
      'name': 'Servo Motor',
      'description': 'Rotary actuator that allows for precise control of angular position.',
      'icon': Icons.rotate_right,
      'color': Colors.redAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IoT Components'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: components.length,
        itemBuilder: (context, index) {
          final comp = components[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: comp['color'].withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(comp['icon'], color: comp['color']),
              ),
              title: Text(
                comp['name'],
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(comp['description']),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: AppTheme.primaryColor),
              onTap: () {
                // Navigate to detail screen
              },
            ),
          );
        },
      ),
    );
  }
}
