import 'package:flutter/material.dart';
import 'chat_room_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFFFB300),
            child: Icon(Icons.person, color: Colors.black),
          ),
          title: const Text('مستخدم الفهد', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: const Text('السلام عليكم، مرحباً بك في الفهد', style: TextStyle(color: Colors.grey)),
          trailing: const Text('10:00 ص', style: TextStyle(color: Colors.grey, fontSize: 12)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatRoomScreen()),
            );
          },
        );
      },
    );
  }
}
