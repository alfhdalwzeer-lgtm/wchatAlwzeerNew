import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class ChatScreen extends StatefulWidget {
  final String userName;

  const ChatScreen({
    super.key,
    required this.userName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final DatabaseHelper _database = DatabaseHelper.instance;

  final String _myUserId = 'current_user';
  late String _otherUserId;
  late String _chatId;

  List<Map<String, dynamic>> _messages = [];
  bool _loading = true;

  final Color _gold = const Color(0xFFD4AF37);
  final Color _background = const Color(0xFF080B0F);
  final Color _incoming = const Color(0xFF1F2C34);
  final Color _outgoing = const Color(0xFF005C4B);

  @override
  void initState() {
    super.initState();

    _otherUserId = widget.userName;
    _chatId = _database.createChatId(
      _myUserId,
      _otherUserId,
    );

    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final messages = await _database.getMessages(_chatId);

    if (!mounted) return;

    setState(() {
      _messages = messages;
      _loading = false;
    });

    await _database.markMessagesAsRead(_chatId);

    _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();

    if (text.isEmpty) return;

    _controller.clear();

    await _database.insertMessage(
      chatId: _chatId,
      senderId: _myUserId,
      receiverId: _otherUserId,
      text: text,
      isMe: true,
      isRead: true,
    );

    await _loadMessages();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _clearChat() async {
    await _database.clearChat(_chatId);

    if (!mounted) return;

    setState(() {
      _messages.clear();
    });
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF151B20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),

              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  'مسح المحادثة',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(context);

                  final confirmed = await showDialog<bool>(
                    context: this.context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: const Color(0xFF1E252B),
                        title: const Text(
                          'مسح المحادثة؟',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: const Text(
                          'سيتم حذف الرسائل المحفوظة في هذه المحادثة.',
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text('إلغاء'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text(
                              'مسح',
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmed == true) {
                    await _clearChat();
                  }
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.close,
                  color: _gold,
                ),
                title: const Text(
                  'إغلاق',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showMediaMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF151B20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'مركز الوسائط',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                  children: [
                    _mediaButton(
                      Icons.camera_alt,
                      'الكاميرا',
                    ),
                    _mediaButton(
                      Icons.photo_library,
                      'المعرض',
                    ),
                    _mediaButton(
                      Icons.videocam,
                      'فيديو',
                    ),
                    _mediaButton(
                      Icons.insert_drive_file,
                      'ملف',
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                _mediaButton(
                  Icons.emoji_emotions,
                  'الملصقات',
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _mediaButton(
    IconData icon,
    String title,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title ستكون متاحة في الخطوة القادمة'),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: _gold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                color: _gold,
                size: 28,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(
    Map<String, dynamic> message,
  ) {
    final bool isMe = message['isMe'] == 1;
    final String text = message['text']?.toString() ?? '';

    final createdAt = message['createdAt'] as int?;
    final time = createdAt == null
        ? ''
        : _formatTime(
            DateTime.fromMillisecondsSinceEpoch(
              createdAt,
            ),
          );

    return Align(
      alignment:
          isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: EdgeInsets.only(
          left: isMe ? 55 : 8,
          right: isMe ? 8 : 55,
          top: 4,
          bottom: 4,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: isMe ? _outgoing : _incoming,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(
              isMe ? 16 : 4,
            ),
            bottomRight: Radius.circular(
              isMe ? 4 : 16,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.35,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              time,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
              ),
            ),
            if (isMe) ...[
              const SizedBox(width: 3),
              Icon(
                Icons.done_all,
                size: 15,
                color: message['isRead'] == 1
                    ? Colors.lightBlueAccent
                    : Colors.white54,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0
        ? 12
        : dateTime.hour % 12;

    final minute =
        dateTime.minute.toString().padLeft(2, '0');

    final period = dateTime.hour >= 12 ? 'م' : 'ص';

    return '$hour:$minute $period';
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _background,
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E2A31),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          titleSpacing: 0,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: _gold,
                child: const Text(
                  '🐆',
                  style: TextStyle(fontSize: 21),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'متصل الآن',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.videocam_outlined,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.call_outlined,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: _showMoreMenu,
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: _loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: _gold,
                      ),
                    )
                  : _messages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.lock_outline,
                                color: _gold,
                                size: 42,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'لا توجد رسائل بعد',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'ابدأ المحادثة الآن',
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            return _buildMessage(
                              _messages[index],
                            );
                          },
                        ),
            ),

            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 7,
                ),
                color: const Color(0xFF080B0F),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E252B),
                          borderRadius:
                              BorderRadius.circular(26),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: _showMediaMenu,
                              icon: Icon(
                                Icons.add,
                                color: _gold,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                textDirection:
                                    TextDirection.rtl,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                minLines: 1,
                                maxLines: 5,
                                decoration:
                                    const InputDecoration(
                                  hintText:
                                      'اكتب رسالة...',
                                  hintStyle: TextStyle(
                                    color: Colors.white38,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 12,
                                  ),
                                ),
                                onSubmitted: (_) {
                                  _sendMessage();
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.emoji_emotions_outlined,
                                color: Colors.white54,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _gold,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: _sendMessage,
                        icon: const Icon(
                          Icons.send,
                          color: Colors.black,
                        ),
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
