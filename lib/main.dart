import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // يمكنك هنا تهيئة Firebase إذا أردت ربطه بقاعدة بيانات سحابية
  runApp(const AlWazirChatApp());
}

class AlWazirChatApp extends StatelessWidget {
  const AlWazirChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تطبيق الفهد',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ChatHomeScreen(),
    );
  }
}

class ChatHomeScreen extends StatelessWidget {
  const ChatHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق الفهد'),
        backgroundColor: Colors.teal[800],
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: 10, // مثال لعدد المحادثات
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.teal,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text('مستخدم رقم ${index + 1}'),
            subtitle: const Text('مرحباً! هذه رسالة تجريبية...'),
            trailing: const Text('10:30 ص', style: TextStyle(color: Colors.grey, fontSize: 12)),
            onTap: () {
              // الانتقال لشاشة المحادثة الخاصة
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[700],
        child: const Icon(Icons.message, color: Colors.white),
        onPressed: () {
          // إضافة محادثة جديدة
        },
      ),
    );
  }
}
