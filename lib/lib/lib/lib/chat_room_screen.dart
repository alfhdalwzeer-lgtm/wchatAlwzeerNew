import 'package:flutter/material.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            CircleAvatar(radius: 16, backgroundColor: Color(0xFFFFB300), child: Icon(Icons.person, size: 20, color: Colors.black)),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('مستخدم الفهد', style: TextStyle(fontSize: 16)),
                Text('متصل الآن', style: TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: const [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    backgroundColor: Color(0xFF1E2636),
                    label: Text('السلام عليكم، مرحباً بك في الفهد\n10:00 ص', style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Chip(
                    backgroundColor: Color(0xFF004D40),
                    label: Text('وعليكم السلام! تطبيق ممتاز جداً\n10:01 ص ✓✓', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: const Color(0xFF161D2A),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.image, color: Color(0xFFFFB300)), onPressed: () {}),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالة...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.mic, color: Color(0xFFFFB300)), onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
