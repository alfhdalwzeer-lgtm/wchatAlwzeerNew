import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AlWazirChatApp());
}

class AlWazirChatApp extends StatelessWidget {
  const AlWazirChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الفهد',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080B0F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4AF37),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF101820),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF18232C),
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.55),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFD4AF37),
              width: 1,
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// ============================================================
// شاشة تسجيل الدخول
// ============================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void login() {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('اكتب اسمك أولاً'),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainHomeScreen(userName: name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),

                // الشعار
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFD4AF37),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.pets,
                    size: 62,
                    color: Color(0xFFD4AF37),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'الفهد',
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Al-Wazir Chat',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 45),

                TextField(
                  controller: nameController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => login(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Color(0xFFD4AF37),
                    ),
                    hintText: 'اكتب اسمك',
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'دخول',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                Text(
                  'محادثات آمنة وسريعة',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// الشاشة الرئيسية
// ============================================================

class MainHomeScreen extends StatefulWidget {
  final String userName;

  const MainHomeScreen({
    super.key,
    required this.userName,
  });

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int currentIndex = 0;

  final List<String> titles = const [
    'الدردشات',
    'المجموعات',
    'المكالمات',
    'الحالة',
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            titles[currentIndex],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingsScreen(
                      userName: widget.userName,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),

        body: IndexedStack(
          index: currentIndex,
          children: [
            ChatsScreen(userName: widget.userName),
            const GroupsScreen(),
            const CallsScreen(),
            const StatusScreen(),
          ],
        ),

        floatingActionButton: currentIndex == 0
            ? FloatingActionButton(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.black,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NewChatScreen(),
                    ),
                  );
                },
                child: const Icon(Icons.chat),
              )
            : null,

        bottomNavigationBar: NavigationBar(
          backgroundColor: const Color(0xFF101820),
          indicatorColor: const Color(0xFFD4AF37).withOpacity(0.18),
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;
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

// ============================================================
// الدردشات
// ============================================================

class ChatsScreen extends StatelessWidget {
  final String userName;

  const ChatsScreen({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 8),
      children: [
        ChatTile(
          name: userName,
          message: 'ابدأ محادثة جديدة',
          time: 'الآن',
          icon: Icons.person,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  name: userName,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ============================================================
// عنصر المحادثة
// ============================================================

class ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final IconData icon;
  final VoidCallback? onTap;

  const ChatTile({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),
      leading: CircleAvatar(
        radius: 27,
        backgroundColor: const Color(0xFF18232C),
        child: Icon(
          icon,
          color: const Color(0xFFD4AF37),
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          message,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withOpacity(0.55),
          ),
        ),
      ),
      trailing: Text(
        time,
        style: TextStyle(
          color: Colors.white.withOpacity(0.45),
          fontSize: 12,
        ),
      ),
    );
  }
}

// ============================================================
// المجموعات
// ============================================================

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: EmptyState(
        icon: Icons.groups_outlined,
        title: 'المجموعات',
        message: 'ستظهر مجموعاتك هنا',
      ),
    );
  }
}

// ============================================================
// المكالمات
// ============================================================

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: EmptyState(
        icon: Icons.call_outlined,
        title: 'المكالمات',
        message: 'لا توجد مكالمات حالياً',
      ),
    );
  }
}

// ============================================================
// الحالة
// ============================================================

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF101820),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFF18232C),
                child: Icon(
                  Icons.add,
                  color: Color(0xFFD4AF37),
                ),
              ),
              SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'حالتي',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'إضافة تحديث جديد',
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// محادثة
// ============================================================

class ChatScreen extends StatefulWidget {
  final String name;

  const ChatScreen({
    super.key,
    required this.name,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final List<String> messages = [];

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void sendMessage() {
    final text = controller.text.trim();

    if (text.isEmpty) return;

    setState(() {
      messages.add(text);
      controller.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.videocam_outlined),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call_outlined),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? const Center(
                      child: Text(
                        'ابدأ المحادثة',
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.only(
                              bottom: 8,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              messages[index],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // شريط الكتابة
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  8,
                  6,
                  8,
                  8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions_outlined,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => sendMessage(),
                        decoration: const InputDecoration(
                          hintText: 'اكتب رسالة...',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(
                        Icons.send,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// محادثة جديدة
// ============================================================

class NewChatScreen extends StatelessWidget {
  const NewChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('محادثة جديدة'),
        ),
        body: const Center(
          child: EmptyState(
            icon: Icons.person_search_outlined,
            title: 'البحث عن مستخدم',
            message: 'سيتم إضافة البحث عن المستخدمين هنا',
          ),
        ),
      ),
    );
  }
}

// ============================================================
// الإعدادات
// ============================================================

class SettingsScreen extends StatelessWidget {
  final String userName;

  const SettingsScreen({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإعدادات'),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 10),

            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF18232C),
                child: Icon(
                  Icons.person,
                  color: Color(0xFFD4AF37),
                ),
              ),
              title: Text(
                userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text('المستخدم'),
            ),

            const Divider(),

            _settingItem(
              icon: Icons.storage_outlined,
              title: 'مساحة التخزين',
              onTap: () {},
            ),

            _settingItem(
              icon: Icons.devices_outlined,
              title: 'الأجهزة المرتبطة',
              onTap: () {},
            ),

            _settingItem(
              icon: Icons.lock_outline,
              title: 'قفل التطبيق',
              onTap: () {},
            ),

            _settingItem(
              icon: Icons.chat_outlined,
              title: 'قفل المحادثات',
              onTap: () {},
            ),

            _settingItem(
              icon: Icons.security_outlined,
              title: 'التحقق بخطوتين',
              onTap: () {},
            ),

            _settingItem(
              icon: Icons.privacy_tip_outlined,
              title: 'الخصوصية والأمان',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  static Widget _settingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: const Color(0xFFD4AF37),
      ),
      title: Text(title),
      trailing: const Icon(
        Icons.chevron_left,
        color: Colors.white38,
      ),
    );
  }
}

// ============================================================
// حالة فارغة
// ============================================================

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 60,
          color: const Color(0xFFD4AF37),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: const TextStyle(
            color: Colors.white54,
          ),
        ),
      ],
    );
  }
}
