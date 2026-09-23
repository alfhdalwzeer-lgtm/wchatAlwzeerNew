import 'package:flutter/material.dart';

void main() {
  runApp(const AlFahdChatApp());
}

class AlFahdChatApp extends StatelessWidget {
  const AlFahdChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق الفهد',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121822),
        primaryColor: const Color(0xFFFFB300),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFB300),
          secondary: Color(0xFFFFB300),
          surface: Color(0xFF1A2230),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF161D2A),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFFFFB300),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Color(0xFFFFB300)),
        ),
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(text: 'السلام عليكم، مرحباً بك في الفهد', isSender: false, time: '10:00 ص'),
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: _controller.text,
        isSender: true,
        time: '10:01 ص',
      ));
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFFFB300),
              child: Icon(Icons.person, color: Colors.black, size: 20),
            ),
            SizedBox(width: 12),
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
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageBubble(
                  text: message.text,
                  isSender: message.isSender,
                  time: message.time,
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            color: const Color(0xFF161D2A),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Color(0xFFFFB300)),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالتك...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mic, color: Color(0xFFFFB300)),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFFFB300)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isSender;
  final String time;

  ChatMessage({required this.text, required this.isSender, required this.time});
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isSender;
  final String time;

  const MessageBubble({
    Key? key,
    required this.text,
    required this.isSender,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSender ? const Color(0xFF004D40) : const Color(0xFF1E2636),
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
                if (isSender) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all, color: Colors.blueAccent, size: 14),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
