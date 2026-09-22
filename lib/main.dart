import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import '../services/database_helper.dart';

class WchatAlwzeerApp extends StatelessWidget {
  const WchatAlwzeerApp({super.key});

  static const gold = Color(0xFFD4AF37);
  static const navy = Color(0xFF1E2A31);
  static const background = Color(0xFF080B0F);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الفهد',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: gold,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ChatsPage(),
    GroupsPage(),
    CallsPage(),
    StatusPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: const Color(0xFF10161B),
          indicatorColor: const Color(0xFFD4AF37).withOpacity(0.18),
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble),
              label: 'الدردشات',
            ),
            NavigationDestination(
              icon: Icon(Icons.groups_outlined),
              selectedIcon: Icon(Icons.groups),
              label: 'المجموعات',
            ),
            NavigationDestination(
              icon: Icon(Icons.call_outlined),
              selectedIcon: Icon(Icons.call),
              label: 'المكالمات',
            ),
            NavigationDestination(
              icon: Icon(Icons.circle_outlined),
              selectedIcon: Icon(Icons.circle),
              label: 'الحالة',
            ),
          ],
        ),
      ),
    );
  }
}

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final DatabaseHelper _database = DatabaseHelper.instance;

  static const String _currentUserId = 'current_user';

  List<Map<String, dynamic>> _chats = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    final chats = await _database.getChatSummaries(
      _currentUserId,
    );

    if (!mounted) return;

    setState(() {
      _chats = chats;
      _loading = false;
    });
  }

  String _otherUser(Map<String, dynamic> chat) {
    final sender = chat['senderId']?.toString() ?? '';
    final receiver = chat['receiverId']?.toString() ?? '';

    if (sender == _currentUserId) {
      return receiver;
    }

    return sender;
  }

  String _formatTime(int? milliseconds) {
    if (milliseconds == null) return '';

    final date =
        DateTime.fromMillisecondsSinceEpoch(milliseconds);

    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute =
        date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'م' : 'ص';

    return '$hour:$minute $period';
  }

  Future<void> _openChat(String userName) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          userName: userName,
        ),
      ),
    );

    _loadChats();
  }

  Future<void> _newChat() async {
    final controller = TextEditingController();

    final userName = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: const Color(0xFF1E252B),
            title: const Text(
              'محادثة جديدة',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: TextField(
              controller: controller,
              autofocus: true,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'اكتب اسم المستخدم',
                hintStyle: const TextStyle(
                  color: Colors.white38,
                ),
                filled: true,
                fillColor: const Color(0xFF10161B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFD4AF37),
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  final name = controller.text.trim();

                  if (name.isEmpty) {
                    return;
                  }

                  Navigator.pop(dialogContext, name);
                },
                child: const Text(
                  'بدء المحادثة',
                ),
              ),
            ],
          ),
        );
      },
    );

    controller.dispose();

    if (!mounted || userName == null) return;

    await _openChat(userName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الفهد',
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.camera_alt_outlined,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'profile',
                child: Text('الملف الشخصي'),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Text('الإعدادات'),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFFD4AF37),
        onRefresh: _loadChats,
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFD4AF37),
                ),
              )
            : _chats.isEmpty
                ? ListView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 60),
                      Icon(
                        Icons.chat_bubble_outline,
                        color: Color(0xFFD4AF37),
                        size: 70,
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'لا توجد محادثات بعد',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          'اضغط زر المحادثة لبدء محادثة جديدة',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    itemCount: _chats.length,
                    itemBuilder: (context, index) {
                      final chat = _chats[index];

                      final userName =
                          _otherUser(chat);
                      final text =
                          chat['text']?.toString() ?? '';
                      final time = _formatTime(
                        chat['createdAt'] as int?,
                      );

                      return _chatTile(
                        name: userName,
                        message: text,
                        time: time,
                        onTap: () =>
                            _openChat(userName),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        foregroundColor: Colors.black,
        onPressed: _newChat,
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _chatTile({
    required String name,
    required String message,
    required String time,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 5,
      ),
      leading: const CircleAvatar(
        radius: 27,
        backgroundColor: Color(0xFFD4AF37),
        child: Text(
          '🐆',
          style: TextStyle(fontSize: 24),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          message,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المجموعات'),
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.groups_outlined,
              color: Color(0xFFD4AF37),
              size: 70,
            ),
            SizedBox(height: 15),
            Text(
              'لا توجد مجموعات بعد',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CallsPage extends StatelessWidget {
  const CallsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المكالمات'),
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.call_outlined,
              color: Color(0xFFD4AF37),
              size: 70,
            ),
            SizedBox(height: 15),
            Text(
              'لا توجد مكالمات بعد',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الحالة'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFFD4AF37),
              child: Text(
                '🐆',
                style: TextStyle(fontSize: 24),
              ),
            ),
            title: const Text(
              'حالتي',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              'اضغط لإضافة حالة جديدة',
              style: TextStyle(
                color: Colors.white54,
              ),
            ),
            onTap: () {},
          ),
          const SizedBox(height: 80),
          const Center(
            child: Icon(
              Icons.auto_awesome,
              color: Color(0xFFD4AF37),
              size: 55,
            ),
          ),
          const SizedBox(height: 15),
          const Center(
            child: Text(
              'لا توجد حالات بعد',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
