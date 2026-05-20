import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _displayName = 'Engineering Student';
  String _universityEmail = 'student@university.edu';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final firebaseUser = FirebaseAuth.instance.currentUser;
    
    // Default name fallback: email prefix or 'Engineering Student'
    String defaultName = 'Engineering Student';
    if (firebaseUser?.email != null) {
      defaultName = firebaseUser!.email!.split('@')[0].toUpperCase();
    }
    
    setState(() {
      _displayName = prefs.getString('profile_name') ?? defaultName;
      _universityEmail = prefs.getString('profile_university') ?? (firebaseUser?.email ?? 'student@university.edu');
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
              if (result == true) {
                _loadProfileData(); // Reload profile if settings were saved
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                          child: const Icon(Icons.person, size: 60, color: AppTheme.primaryColor),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _displayName,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _universityEmail,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn(context, '12', 'Projects\nDone'),
                      _buildStatColumn(context, '85%', 'Quiz\nAverage'),
                      _buildStatColumn(context, '5', 'Certificates\nEarned'),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Options List
                  _buildListTile(context, Icons.bookmark, 'Saved Projects'),
                  _buildListTile(context, Icons.history, 'Learning History'),
                  _buildListTile(context, Icons.download, 'Downloaded Resources'),
                  _buildListTile(context, Icons.group, 'Community Discussion'),
                  
                  const SizedBox(height: 32),
                  
                  // Logout Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Perform Logout Logic via FirebaseAuth
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondaryColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.accentColor),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showDetailSheet(context, title),
      ),
    );
  }

  void _showDetailSheet(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        List<Map<String, dynamic>> items = [];
        IconData categoryIcon = Icons.info_outline;
        Color accentColor = AppTheme.primaryColor;

        if (title == 'Saved Projects') {
          categoryIcon = Icons.bookmark_added_outlined;
          accentColor = AppTheme.primaryColor;
          items = [
            {
              'title': 'Smart Home Automation Controller',
              'desc': 'ESP32 web server with relays controlling household lights.',
              'status': 'Bookmarked',
            },
            {
              'title': 'IoT Weather Station Dashboard',
              'desc': 'Real-time temperature and humidity logging via DHT22 and Firebase.',
              'status': 'In Progress',
            },
            {
              'title': 'RFID Smart Lock Entry System',
              'desc': 'Secure entry with RC522 module, servo lock, and log records.',
              'status': 'Saved Draft',
            },
          ];
        } else if (title == 'Learning History') {
          categoryIcon = Icons.history_edu_outlined;
          accentColor = AppTheme.accentColor;
          items = [
            {
              'title': 'ESP32 Web Server Setup & Hosting',
              'desc': 'Watched: 100% • Date: May 18, 2026',
              'status': 'Completed',
            },
            {
              'title': 'MQTT Protocols & Broker Setup',
              'desc': 'Watched: 80% • Date: May 15, 2026',
              'status': 'In Progress',
            },
            {
              'title': 'Microcontroller Pinout Basics',
              'desc': 'Watched: 100% • Date: May 10, 2026',
              'status': 'Completed',
            },
          ];
        } else if (title == 'Downloaded Resources') {
          categoryIcon = Icons.download_done_outlined;
          accentColor = Colors.orangeAccent;
          items = [
            {
              'title': 'ESP32 Technical Datasheet & Pinout.pdf',
              'desc': 'Size: 2.4 MB • Format: PDF Guide',
              'status': 'Download Active',
            },
            {
              'title': 'Arduino C++ Syntax Cheat Sheet.pdf',
              'desc': 'Size: 1.1 MB • Quick Reference Guide',
              'status': 'Offline Available',
            },
            {
              'title': 'IoT Sensors Wiring Diagram Bundle.zip',
              'desc': 'Size: 8.5 MB • Circuit Diagrams & Code',
              'status': 'Offline Available',
            },
          ];
        } else if (title == 'Community Discussion') {
          categoryIcon = Icons.forum_outlined;
          accentColor = Colors.greenAccent;
          items = [
            {
              'title': '@esp_master: "WiFi disconnection issue resolved!"',
              'desc': 'Topic: Fixing random disconnections using static IPs.',
              'status': '14 replies',
            },
            {
              'title': '@iot_newbie: "Best humidity sensor for beginners?"',
              'desc': 'Topic: Comparing DHT11 vs DHT22 vs BME280.',
              'status': '8 replies',
            },
            {
              'title': '@iot_expert: "MQTT vs HTTP comparison guide"',
              'desc': 'Topic: Detailed benchmark on ESP8266 devices.',
              'status': '22 replies',
            },
          ];
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(categoryIcon, color: accentColor, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 1, color: AppTheme.backgroundColor),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: AppTheme.backgroundColor,
                      child: ListTile(
                        title: Text(
                          item['title']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            item['desc']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            item['status']!,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
