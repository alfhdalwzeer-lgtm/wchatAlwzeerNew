import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'status_screen.dart';
import 'groups_screen.dart';
import 'calls_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 3; // تبويب الدردسات افتراضياً

  final List<Widget> _screens = [
    const StatusScreen(),
    const CallsScreen(),
    const GroupsScreen(),
    const ChatListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121822),
      appBar: AppBar(
        backgroundColor: const Color(0xFF18222C),
        title: const Text(
          'الفهد',
          style: TextStyle(color: Color(0xFFE5C158), fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Color(0xFFE5C158)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFFE5C158)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF18222C),
        selectedItemColor: const Color(0xFFE5C158),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.data_usage), label: 'الحالة'),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'المكالمات'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'المجموعات'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'الدردشات'),
        ],
      ),
    );
  }
}
