import 'package:flutter/material.dart';

void main() => runApp(const AlFahdChatApp());

class AlFahdChatApp extends StatelessWidget {
  const AlFahdChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AlFahd Chat',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121822),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF161D2A),
          elevation: 0,
        ),
      ),
      home: const SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الإعدادات',
          style: TextStyle(color: Color(0xFFFFFB30)),
        ),
      ),
      body: ListView(
        children: [
          // معلومات المستخدم الشخصية في أعلى الإعدادات[span_0](start_span)[span_0](end_span)
          Container(
            padding: const EdgeInsets.all(18),
            color: const Color(0xFF161D2A),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Color(0xFFFFFB30),
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'صادق الوزير',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'متصل الآن',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // خيارات الإعدادات المتنوعة[span_1](start_span)[span_1](end_span)[span_2](start_span)[span_2](end_span)
          _setting(
            Icons.key,
            'الحساب',
            'الأمان، تغيير الرقم، حذف الحساب',
          ),
          _setting(
            Icons.lock_outline,
            'الخصوصية',
            'آخر ظهور، الصورة الشخصية، الحالة',
          ),
          _setting(
            Icons.chat_bubble_outline,
            'الدردشات',
            'الخلفية، سجل الدردشات، الإرسال',
          ),
          _setting(
            Icons.notifications_none,
            'الإشعارات',
            'نغمات الرسائل والمكالمات',
          ),
          _setting(
            Icons.storage,
            'التخزين والبيانات',
            'إدارة استخدام الشبكة والوسائط',
          ),

          // زر التبديل للوضع الداكن[span_3](start_span)[span_3](end_span)
          SwitchListTile(
            secondary: const Icon(
              Icons.nightlight_round,
              color: Color(0xFFFFFB30),
            ),
            title: const Text(
              'الوضع الداكن',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'المظهر الداكن للفهد',
              style: TextStyle(color: Colors.grey),
            ),
            value: true,
            activeColor: const Color(0xFFFFFB30),
            onChanged: (_) {},
          ),

          _setting(
            Icons.language,
            'لغة التطبيق',
            'العربية',
          ),
          _setting(
            Icons.help_outline,
            'المساعدة',
            'مركز المساعدة واتصل بنا',
          ),
          _setting(
            Icons.info,
            'حول الفهد',
            'الإصدار 1.0.0',
          ),

          const Divider(color: Colors.grey),

          // زر تسجيل الخروج والنافذة الخاصة به[span_4](start_span)[span_4](end_span)[span_5](start_span)[span_5](end_span)[span_6](start_span)[span_6](end_span)
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: const Text(
              'تسجيل الخروج',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              'تسجيل الخروج من الحساب الحالي',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              _logoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  // دالة لإنشاء عناصر الإعدادات المتكررة بنسق واحد[span_7](start_span)[span_7](end_span)
  Widget _setting(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFFFFFB30),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey),
      ),
      onTap: () {},
    );
  }

  // نافذة تأكيد تسجيل الخروج[span_8](start_span)[span_8](end_span)[span_9](start_span)[span_9](end_span)[span_10](start_span)[span_10](end_span)
  void _logoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF161D2A),
          title: const Text(
            'تسجيل الخروج',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text(
            'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'إلغاء',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تسجيل الخروج بنجاح'),
                  ),
                );
              },
              child: const Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
