import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'dashboard_screen.dart';
import '../chatbot/chat_screen.dart';
import '../components/component_list_screen.dart';
import '../profile/profile_screen.dart';
import '../shop/qr_kit_screen.dart';
import '../../theme/app_theme.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _bottomNavIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const ComponentListScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  final iconList = <IconData>[
    Icons.dashboard_rounded,
    Icons.memory_rounded,
    Icons.chat_bubble_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_bottomNavIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const QRKitScreen()),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.qr_code_scanner, color: AppTheme.backgroundColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        backgroundColor: AppTheme.surfaceColor,
        activeColor: AppTheme.primaryColor,
        inactiveColor: AppTheme.textSecondary,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}
