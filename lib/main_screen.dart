import 'packaimport  
'packagege:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // قائمة الشاشات الرئيسية للتطبيق
  final List<Widget> _screens = [
    const ChatsListScreen(),
    const Center(child: Text('المجموعات', style: TextStyle(color: Colors.white, fontSize: 18))),
    const Center(child: Text('المكالمات', style: TextStyle(color: Colors.white, fontSize: 18))),
    const StatusListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الفهد', style: TextStyle(color: Color(0xFFFFB300), fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF161D2A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFFFFB300)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Color(0xFFFFB300)),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFFFFB300)),
            onSelected: (value) {
              if (value == 'settings') {
                // الانتقال لصفحة الإعدادات مستقبلاً
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Text('الإعدادات'),
              ),
            ],
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF161D2A),
        selectedItemColor: const Color(0xFFFFB300),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'الدردسات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
                     label: 'المجموعات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'المكالمات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.donut_large),
            label: 'الحالة',
          ),
        ],
      ),
    );
  }
}

// شاشة عرض قائمة الدردسات
class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFFFB300),
            child: Icon(Icons.person, color: Colors.black),
          ),
          title: const Text('مستخدم الفهد', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: const Text('السلام عليكم، مرحباً بك في الفهد', style: TextStyle(color: Colors.grey)),
          trailing: const Text('10:00 ص', style: TextStyle(color: Colors.grey, fontSize: 12)),
          onTap: () {
            // الانتقال إلى غرفة المحادثة
          },
        ),
      ],
    );
  }  
     }

// شاشة عرض الحالة
class StatusListScreen extends StatelessWidget {
  const StatusListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121822),
      body: ListView(
        children: [
          ListTile(
            leading: Stack(
              children: const [
                CircleAvatar(
                  backgroundColor: Color(0xFFFFB300),
                  child: Icon(Icons.person, color: Colors.black),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 7,
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
            title: const Text('حالتي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: const Text('اضغط لإضافة حالة جديدة', style: TextStyle(color: Colors.grey)),
            onTap: () {},
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'التحديثات الحديثة',
              style: TextStyle(color: Color(0xFFFFB300), fontWeight: FontWeight.bold),
            ),
          ),        
           
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Text('لا توجد حالات بعد', style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFB300),
        child: const Icon(Icons.camera_alt, color: Colors.black),
        onPressed: () {},
      ),
    );
  }
}
            
