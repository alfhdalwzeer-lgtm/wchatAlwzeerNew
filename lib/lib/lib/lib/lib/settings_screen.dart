import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.security, color: Color(0xFFFFB300)),
            title: const Text('الأمان'),
            subtitle: const Text('إعدادات حماية الحساب'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.data_usage, color: Color(0xFFFFB300)),
            title: const Text('البيانات والتخزين'),
            subtitle: const Text('إدارة الوسائط والبيانات'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.palette, color: Color(0xFFFFB300)),
            title: const Text('المظهر'),
            subtitle: const Text('الوضع الداكن لـ الفهد'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language, color: Color(0xFFFFB300)),
            title: const Text('اللغة'),
            subtitle: const Text('العربية'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Color(0xFFFFB300)),
            title: const Text('حول التطبيق'),
            subtitle: const Text('الإصدار 1.0.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
