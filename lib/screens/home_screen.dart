import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'status_screen.dart';
import 'groups_screen.dart';
import 'calls_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'storage_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ChatScreen(),
    const StatusScreen(),
    const GroupsScreen(),
    const CallsScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
    const StorageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      app: AppBar(
        title: const Text('Al-Wazir Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex > 3 ? 0 : _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'الدردشة'),
          BottomNavigationBarItem(icon: Icon(Icons.data_usage), label: 'الحالة'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'المجموعات'),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'المكالمات'),
        ],
      ),
    );
  }
}
