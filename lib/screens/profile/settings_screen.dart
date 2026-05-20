import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController();
  final _uniController = TextEditingController();
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final firebaseUser = FirebaseAuth.instance.currentUser;
    
    // Default name fallback: email prefix or 'Engineering Student'
    String defaultName = 'Engineering Student';
    if (firebaseUser?.email != null) {
      defaultName = firebaseUser!.email!.split('@')[0].toUpperCase();
    }
    
    setState(() {
      _nameController.text = prefs.getString('profile_name') ?? defaultName;
      _uniController.text = prefs.getString('profile_university') ?? (firebaseUser?.email ?? 'student@university.edu');
      _notificationsEnabled = prefs.getBool('settings_notifications') ?? true;
      _darkModeEnabled = prefs.getBool('settings_dark_mode') ?? true;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', _nameController.text.trim());
    await prefs.setString('profile_university', _uniController.text.trim());
    await prefs.setBool('settings_notifications', _notificationsEnabled);
    await prefs.setBool('settings_dark_mode', _darkModeEnabled);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved successfully!')),
      );
      Navigator.pop(context, true); // Return true to trigger reload on Profile Screen
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _uniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Profile Settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primaryColor,
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Display Name',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _uniController,
                            decoration: const InputDecoration(
                              labelText: 'University / Email',
                              prefixIcon: Icon(Icons.school_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Preferences',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primaryColor,
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Push Notifications'),
                          subtitle: const Text('Get alerts about new projects & quizzes'),
                          secondary: const Icon(Icons.notifications_active_outlined, color: AppTheme.accentColor),
                          value: _notificationsEnabled,
                          activeThumbColor: AppTheme.primaryColor,
                          onChanged: (val) {
                            setState(() {
                              _notificationsEnabled = val;
                            });
                          },
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          title: const Text('Cyberpunk Dark Mode'),
                          subtitle: const Text('Enable futuristic neon UI styling'),
                          secondary: const Icon(Icons.dark_mode_outlined, color: AppTheme.accentColor),
                          value: _darkModeEnabled,
                          activeThumbColor: AppTheme.primaryColor,
                          onChanged: (val) {
                            setState(() {
                              _darkModeEnabled = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'App Info',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primaryColor,
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(height: 12),
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('App Version', style: TextStyle(color: AppTheme.textSecondary)),
                              Text('1.0.0 (Release)', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Backend Service', style: TextStyle(color: AppTheme.textSecondary)),
                              Text('Firebase Active', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('AI Engine', style: TextStyle(color: AppTheme.textSecondary)),
                              Text('Groq Llama 3.1', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _saveSettings,
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
    );
  }
}
