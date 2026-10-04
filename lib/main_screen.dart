import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ===============================================================
/// 🐆 Al-Wazir Chat / الفهد
/// main_screen.dart
///
/// - واجهة RTL عربية
/// - تخزين دائم للبيانات
/// - الدردشات والرسائل
/// - المجموعات
/// - الحالات
/// - القنوات
/// - سجل المكالمات
/// - الإعدادات والملف الشخصي
///
/// ملاحظة:
/// هذا الملف يبني النواة المحلية الحقيقية للتطبيق.
/// خدمات Bluetooth / Wi-Fi Direct / Firebase / التسجيل الصوتي
/// سيتم ربطها بالـ APIs الموجودة في pubspec في الخطوات التالية.
/// ===============================================================

const Color kGold = Color(0xFFD4AF37);
const Color kBackground = Color(0xFF0D131A);
const Color kAppBar = Color(0xFF101820);
const Color kPanel = Color(0xFF18232C);
const Color kPanelLight = Color(0xFF202E38);

String _newId() => DateTime.now().microsecondsSinceEpoch.toString();

String _dateTimeText(DateTime date) {
  final h = date.hour.toString().padLeft(2, '0');
  final m = date.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

String _dayText(DateTime date) {
  final now = DateTime.now();

  if (date.year == now.year &&
      date.month == now.month &&
      date.day == now.day) {
    return _dateTimeText(date);
  }

  return '${date.day}/${date.month}';
}

String _relativeTime(DateTime date) {
  final difference = DateTime.now().difference(date);

  if (difference.inMinutes < 1) {
    return 'الآن';
  }

  if (difference.inMinutes < 60) {
    return 'منذ ${difference.inMinutes} دقيقة';
  }

  if (difference.inHours < 24) {
    return 'منذ ${difference.inHours} ساعة';
  }

  if (difference.inDays == 1) {
    return 'أمس';
  }

  return '${date.day}/${date.month}';
}

/// ===============================================================
/// ENUMS
/// ===============================================================

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

enum MessageType {
  text,
  image,
  video,
  file,
  audio,
  location,
  contact,
  sticker,
  gif,
}

enum CallType {
  voice,
  video,
}

enum CallDirection {
  incoming,
  outgoing,
  missed,
}

/// ===============================================================
/// ACCOUNT
/// ===============================================================

class AlWazirAccount {
  final String id;
  final String name;
  final String phone;
  final String countryCode;
  final String photoPath;
  final DateTime? createdAt;

  const AlWazirAccount({
    required this.id,
    required this.name,
    required this.phone,
    required this.countryCode,
    required this.photoPath,
    required this.createdAt,
  });

  factory AlWazirAccount.empty() {
    return const AlWazirAccount(
      id: '',
      name: '',
      phone: '',
      countryCode: '+967',
      photoPath: '',
      createdAt: null,
    );
  }

  AlWazirAccount copyWith({
    String? id,
    String? name,
    String? phone,
    String? countryCode,
    String? photoPath,
    DateTime? createdAt,
  }) {
    return AlWazirAccount(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'countryCode': countryCode,
      'photoPath': photoPath,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory AlWazirAccount.fromMap(Map<String, dynamic> map) {
    return AlWazirAccount(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      countryCode: map['countryCode']?.toString() ?? '+967',
      photoPath: map['photoPath']?.toString() ?? '',
      createdAt: map['createdAt'] == null
          ? null
          : DateTime.tryParse(map['createdAt'].toString()),
    );
  }
}

/// ===============================================================
/// SETTINGS
/// ===============================================================

class AlWazirSettings {
  final bool notificationsEnabled;
  final bool readReceipts;
  final bool lastSeenEnabled;
  final bool statusPrivacyEnabled;
  final bool appLockEnabled;
  final bool chatLockEnabled;
  final bool twoStepEnabled;
  final bool darkMode;
  final String language;

  const AlWazirSettings({
    required this.notificationsEnabled,
    required this.readReceipts,
    required this.lastSeenEnabled,
    required this.statusPrivacyEnabled,
    required this.appLockEnabled,
    required this.chatLockEnabled,
    required this.twoStepEnabled,
    required this.darkMode,
    required this.language,
  });

  factory AlWazirSettings.defaults() {
    return const AlWazirSettings(
      notificationsEnabled: true,
      readReceipts: true,
      lastSeenEnabled: true,
      statusPrivacyEnabled: true,
      appLockEnabled: false,
      chatLockEnabled: false,
      twoStepEnabled: false,
      darkMode: true,
      language: 'العربية',
    );
  }

  AlWazirSettings copyWith({
    bool? notificationsEnabled,
    bool? readReceipts,
    bool? lastSeenEnabled,
    bool? statusPrivacyEnabled,
    bool? appLockEnabled,
    bool? chatLockEnabled,
    bool? twoStepEnabled,
    bool? darkMode,
    String? language,
  }) {
    return AlWazirSettings(
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      readReceipts: readReceipts ?? this.readReceipts,
      lastSeenEnabled: lastSeenEnabled ?? this.lastSeenEnabled,
      statusPrivacyEnabled:
          statusPrivacyEnabled ?? this.statusPrivacyEnabled,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      chatLockEnabled: chatLockEnabled ?? this.chatLockEnabled,
      twoStepEnabled: twoStepEnabled ?? this.twoStepEnabled,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'readReceipts': readReceipts,
      'lastSeenEnabled': lastSeenEnabled,
      'statusPrivacyEnabled': statusPrivacyEnabled,
      'appLockEnabled': appLockEnabled,
      'chatLockEnabled': chatLockEnabled,
      'twoStepEnabled': twoStepEnabled,
      'darkMode': darkMode,
      'language': language,
    };
  }

  factory AlWazirSettings.fromMap(Map<String, dynamic> map) {
    return AlWazirSettings(
      notificationsEnabled: map['notificationsEnabled'] != false,
      readReceipts: map['readReceipts'] != false,
      lastSeenEnabled: map['lastSeenEnabled'] != false,
      statusPrivacyEnabled: map['statusPrivacyEnabled'] != false,
      appLockEnabled: map['appLockEnabled'] == true,
      chatLockEnabled: map['chatLockEnabled'] == true,
      twoStepEnabled: map['twoStepEnabled'] == true,
      darkMode: map['darkMode'] != false,
      language: map['language']?.toString() ?? 'العربية',
    );
  }
}

/// ===============================================================
/// CHAT
/// ===============================================================

class AlWazirChat {
  final String id;
  final String name;
  final String phone;
  final String avatarPath;
  final String lastMessage;
  final DateTime? lastTime;
  final int unread;
  final bool pinned;
  final bool muted;
  final bool locked;

  const AlWazirChat({
    required this.id,
    required this.name,
    required this.phone,
    required this.avatarPath,
    required this.lastMessage,
    required this.lastTime,
    required this.unread,
    required this.pinned,
    required this.muted,
    required this.locked,
  });

  factory AlWazirChat.fromMap(Map<String, dynamic> map) {
    return AlWazirChat(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      avatarPath: map['avatarPath']?.toString() ?? '',
      lastMessage: map['lastMessage']?.toString() ?? '',
      lastTime: map['lastTime'] == null
          ? null
          : DateTime.tryParse(map['lastTime'].toString()),
      unread: (map['unread'] as num?)?.toInt() ?? 0,
      pinned: map['pinned'] == true,
      muted: map['muted'] == true,
      locked: map['locked'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'avatarPath': avatarPath,
      'lastMessage': lastMessage,
      'lastTime': lastTime?.toIso8601String(),
      'unread': unread,
      'pinned': pinned,
      'muted': muted,
      'locked': locked,
    };
  }

  AlWazirChat copyWith({
    String? id,
    String? name,
    String? phone,
    String? avatarPath,
    String? lastMessage,
    DateTime? lastTime,
    int? unread,
    bool? pinned,
    bool? muted,
    bool? locked,
  }) {
    return AlWazirChat(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarPath: avatarPath ?? this.avatarPath,
      lastMessage: lastMessage ?? this.lastMessage,
      lastTime: lastTime ?? this.lastTime,
      unread: unread ?? this.unread,
      pinned: pinned ?? this.pinned,
      muted: muted ?? this.muted,
      locked: locked ?? this.locked,
    );
  }
}

/// ===============================================================
/// MESSAGE
/// ===============================================================

class AlWazirMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String text;
  final String mediaPath;
  final MessageType type;
  final MessageStatus status;
  final DateTime createdAt;
  final String replyToId;
  final String replyText;
  final bool deletedForMe;
  final bool deletedForEveryone;
  final bool pinned;
  final bool edited;

  const AlWazirMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.mediaPath,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.replyToId,
    required this.replyText,
    required this.deletedForMe,
    required this.deletedForEveryone,
    required this.pinned,
    required this.edited,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'mediaPath': mediaPath,
      'type': type.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'replyToId': replyToId,
      'replyText': replyText,
      'deletedForMe': deletedForMe,
      'deletedForEveryone': deletedForEveryone,
      'pinned': pinned,
      'edited': edited,
    };
  }

  factory AlWazirMessage.fromMap(Map<String, dynamic> map) {
    final type = MessageType.values.firstWhere(
      (value) => value.name == map['type'],
      orElse: () => MessageType.text,
    );

    final status = MessageStatus.values.firstWhere(
      (value) => value.name == map['status'],
      orElse: () => MessageStatus.sent,
    );

    return AlWazirMessage(
      id: map['id']?.toString() ?? '',
      chatId: map['chatId']?.toString() ?? '',
      senderId: map['senderId']?.toString() ?? '',
      text: map['text']?.toString() ?? '',
      mediaPath: map['mediaPath']?.toString() ?? '',
      type: type,
      status: status,
      createdAt: DateTime.tryParse(
            map['createdAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
      replyToId: map['replyToId']?.toString() ?? '',
      replyText: map['replyText']?.toString() ?? '',
      deletedForMe: map['deletedForMe'] == true,
      deletedForEveryone: map['deletedForEveryone'] == true,
      pinned: map['pinned'] == true,
      edited: map['edited'] == true,
    );
  }

  AlWazirMessage copyWith({
    String? text,
    String? mediaPath,
    MessageType? type,
    MessageStatus? status,
    String? replyToId,
    String? replyText,
    bool? deletedForMe,
    bool? deletedForEveryone,
    bool? pinned,
    bool? edited,
  }) {
    return AlWazirMessage(
      id: id,
      chatId: chatId,
      senderId: senderId,
      text: text ?? this.text,
      mediaPath: mediaPath ?? this.mediaPath,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt,
      replyToId: replyToId ?? this.replyToId,
      replyText: replyText ?? this.replyText,
      deletedForMe: deletedForMe ?? this.deletedForMe,
      deletedForEveryone:
          deletedForEveryone ?? this.deletedForEveryone,
      pinned: pinned ?? this.pinned,
      edited: edited ?? this.edited,
    );
  }
}

/// ===============================================================
/// GROUP
/// ===============================================================

class AlWazirGroup {
  final String id;
  final String name;
  final String photoPath;
  final List<String> members;
  final List<String> admins;
  final DateTime createdAt;

  const AlWazirGroup({
    required this.id,
    required this.name,
    required this.photoPath,
    required this.members,
    required this.admins,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photoPath': photoPath,
      'members': members,
      'admins': admins,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AlWazirGroup.fromMap(Map<String, dynamic> map) {
    return AlWazirGroup(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      photoPath: map['photoPath']?.toString() ?? '',
      members: List<String>.from(
        (map['members'] as List?) ?? const [],
      ),
      admins: List<String>.from(
        (map['admins'] as List?) ?? const [],
      ),
      createdAt: DateTime.tryParse(
            map['createdAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
    );
  }
}

/// ===============================================================
/// STATUS
/// ===============================================================

class AlWazirStatus {
  final String id;
  final String ownerName;
  final String text;
  final String mediaPath;
  final DateTime createdAt;
  final int views;

  const AlWazirStatus({
    required this.id,
    required this.ownerName,
    required this.text,
    required this.mediaPath,
    required this.createdAt,
    required this.views,
  });

  bool get expired =>
      DateTime.now().difference(createdAt).inHours >= 24;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerName': ownerName,
      'text': text,
      'mediaPath': mediaPath,
      'createdAt': createdAt.toIso8601String(),
      'views': views,
    };
  }

  factory AlWazirStatus.fromMap(Map<String, dynamic> map) {
    return AlWazirStatus(
      id: map['id']?.toString() ?? '',
      ownerName: map['ownerName']?.toString() ?? '',
      text: map['text']?.toString() ?? '',
      mediaPath: map['mediaPath']?.toString() ?? '',
      createdAt: DateTime.tryParse(
            map['createdAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
      views: (map['views'] as num?)?.toInt() ?? 0,
    );
  }
}

/// ===============================================================
/// CHANNEL
/// ===============================================================

class AlWazirChannelPost {
  final String id;
  final String text;
  final DateTime createdAt;
  final int likes;

  const AlWazirChannelPost({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.likes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
    };
  }

  factory AlWazirChannelPost.fromMap(Map<String, dynamic> map) {
    return AlWazirChannelPost(
      id: map['id']?.toString() ?? '',
      text: map['text']?.toString() ?? '',
      createdAt: DateTime.tryParse(
            map['createdAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
      likes: (map['likes'] as num?)?.toInt() ?? 0,
    );
  }
}

class AlWazirChannel {
  final String id;
  final String name;
  final String description;
  final bool verified;
  final bool followed;
  final List<AlWazirChannelPost> posts;

  const AlWazirChannel({
    required this.id,
    required this.name,
    required this.description,
    required this.verified,
    required this.followed,
    required this.posts,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'verified': verified,
      'followed': followed,
      'posts': posts.map((e) => e.toMap()).toList(),
    };
  }

  factory AlWazirChannel.fromMap(Map<String, dynamic> map) {
    return AlWazirChannel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      verified: map['verified'] == true,
      followed: map['followed'] == true,
      posts: ((map['posts'] as List?) ?? const [])
          .whereType<Map>()
          .map(
            (item) => AlWazirChannelPost.fromMap(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
    );
  }

  AlWazirChannel copyWith({
    bool? followed,
    List<AlWazirChannelPost>? posts,
  }) {
    return AlWazirChannel(
      id: id,
      name: name,
      description: description,
      verified: verified,
      followed: followed ?? this.followed,
      posts: posts ?? this.posts,
    );
  }
}

/// ===============================================================
/// CALL
/// ===============================================================

class AlWazirCall {
  final String id;
  final String name;
  final CallType type;
  final CallDirection direction;
  final DateTime createdAt;

  const AlWazirCall({
    required this.id,
    required this.name,
    required this.type,
    required this.direction,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'direction': direction.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AlWazirCall.fromMap(Map<String, dynamic> map) {
    final type = CallType.values.firstWhere(
      (e) => e.name == map['type'],
      orElse: () => CallType.voice,
    );

    final direction = CallDirection.values.firstWhere(
      (e) => e.name == map['direction'],
      orElse: () => CallDirection.incoming,
    );

    return AlWazirCall(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      type: type,
      direction: direction,
      createdAt: DateTime.tryParse(
            map['createdAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
    );
  }
}

/// ===============================================================
/// 🧠 AlWazirCore
///
/// النواة المحلية للتطبيق.
/// كل تغيير مهم يتم حفظه في SharedPreferences.
/// ===============================================================

class AlWazirCore extends ChangeNotifier {
  AlWazirCore._();

  static final AlWazirCore instance = AlWazirCore._();

  SharedPreferences? _prefs;

  bool initialized = false;

  AlWazirAccount account = AlWazirAccount.empty();

  AlWazirSettings settings = AlWazirSettings.defaults();

  final List<AlWazirChat> chats = [];

  final Map<String, List<AlWazirMessage>> messages = {};

  final List<AlWazirGroup> groups = [];

  final List<AlWazirStatus> statuses = [];

  final List<AlWazirChannel> channels = [];

  final List<AlWazirCall> calls = [];

  static const String _accountKey = 'fahad.account.v2';
  static const String _settingsKey = 'fahad.settings.v2';
  static const String _chatsKey = 'fahad.chats.v2';
  static const String _messagesKey = 'fahad.messages.v2';
  static const String _groupsKey = 'fahad.groups.v2';
  static const String _statusesKey = 'fahad.statuses.v2';
  static const String _channelsKey = 'fahad.channels.v2';
  static const String _callsKey = 'fahad.calls.v2';

  Future<void> init() async {
    if (initialized) return;

    _prefs = await SharedPreferences.getInstance();

    await _loadAccount();
    await _loadSettings();
    await _loadChats();
    await _loadMessages();
    await _loadGroups();
    await _loadStatuses();
    await _loadChannels();
    await _loadCalls();

    _removeExpiredStatuses();

    if (channels.isEmpty) {
      channels.add(
        AlWazirChannel(
          id: 'official-fahad-channel',
          name: 'قناة الفهد الرسمية',
          description: 'آخر الأخبار والتحديثات والإعلانات',
          verified: true,
          followed: true,
          posts: [
            AlWazirChannelPost(
              id: _newId(),
              text: 'مرحبًا بكم في قناة الفهد الرسمية 🐆',
              createdAt: DateTime.now(),
              likes: 0,
            ),
          ],
        ),
      );

      await _saveChannels();
    }

    initialized = true;
    notifyListeners();
  }

  Future<void> ensureReady() async {
    if (!initialized) {
      await init();
    }
  }

  Future<void> _loadAccount() async {
    final value = _prefs?.getString(_accountKey);

    if (value == null || value.isEmpty) return;

    try {
      account = AlWazirAccount.fromMap(
        Map<String, dynamic>.from(jsonDecode(value)),
      );
    } catch (_) {}
  }

  Future<void> _loadSettings() async {
    final value = _prefs?.getString(_settingsKey);

    if (value == null || value.isEmpty) return;

    try {
      settings = AlWazirSettings.fromMap(
        Map<String, dynamic>.from(jsonDecode(value)),
      );
    } catch (_) {}
  }

  Future<void> _loadChats() async {
    final value = _prefs?.getString(_chatsKey);

    if (value == null || value.isEmpty) return;

    try {
      final list = jsonDecode(value) as List;

      chats
        ..clear()
        ..addAll(
          list
              .whereType<Map>()
              .map(
                (item) => AlWazirChat.fromMap(
                  Map<String, dynamic>.from(item),
                ),
              ),
        );
    } catch (_) {}
  }

  Future<void> _loadMessages() async {
    final value = _prefs?.getString(_messagesKey);

    if (value == null || value.isEmpty) return;

    try {
      final map = Map<String, dynamic>.from(jsonDecode(value));

      messages.clear();

      for (final entry in map.entries) {
        final list = entry.value as List;

        messages[entry.key] = list
            .whereType<Map>()
            .map(
              (item) => AlWazirMessage.fromMap(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
      }
    } catch (_) {}
  }

  Future<void> _loadGroups() async {
    final value = _prefs?.getString(_groupsKey);

    if (value == null || value.isEmpty) return;

    try {
      final list = jsonDecode(value) as List;

      groups
        ..clear()
        ..addAll(
          list
              .whereType<Map>()
              .map(
                (item) => AlWazirGroup.fromMap(
                  Map<String, dynamic>.from(item),
                ),
              ),
        );
    } catch (_) {}
  }

  Future<void> _loadStatuses() async {
    final value = _prefs?.getString(_statusesKey);

    if (value == null || value.isEmpty) return;

    try {
      final list = jsonDecode(value) as List;

      statuses
        ..clear()
        ..addAll(
          list
              .whereType<Map>()
              .map(
                (item) => AlWazirStatus.fromMap(
                  Map<String, dynamic>.from(item),
                ),
              ),
        );
    } catch (_) {}
  }

  Future<void> _loadChannels() async {
    final value = _prefs?.getString(_channelsKey);

    if (value == null || value.isEmpty) return;

    try {
      final list = jsonDecode(value) as List;

      channels
        ..clear()
        ..addAll(
          list
              .whereType<Map>()
              .map(
                (item) => AlWazirChannel.fromMap(
                  Map<String, dynamic>.from(item),
                ),
              ),
        );
    } catch (_) {}
  }

  Future<void> _loadCalls() async {
    final value = _prefs?.getString(_callsKey);

    if (value == null || value.isEmpty) return;

    try {
      final list = jsonDecode(value) as List;

      calls
        ..clear()
        ..addAll(
          list
              .whereType<Map>()
              .map(
                (item) => AlWazirCall.fromMap(
                  Map<String, dynamic>.from(item),
                ),
              ),
        );
    } catch (_) {}
  }

  void _removeExpiredStatuses() {
    statuses.removeWhere((status) => status.expired);
  }

  Future<void> _saveString(
    String key,
    String value,
  ) async {
    await _prefs?.setString(key, value);
  }

  Future<void> saveAccount(AlWazirAccount value) async {
    await ensureReady();

    account = value;

    await _saveString(
      _accountKey,
      jsonEncode(account.toMap()),
    );

    notifyListeners();
  }

  Future<void> updateSettings(
    AlWazirSettings value,
  ) async {
    await ensureReady();

    settings = value;

    await _saveString(
      _settingsKey,
      jsonEncode(settings.toMap()),
    );

    notifyListeners();
  }

  AlWazirChat? chat(String id) {
    for (final item in chats) {
      if (item.id == id) return item;
    }

    return null;
  }

  List<AlWazirMessage> chatMessages(String chatId) {
    return messages.putIfAbsent(chatId, () => []);
  }

  Future<AlWazirChat> createChat({
    required String name,
    String phone = '',
  }) async {
    await ensureReady();

    final chat = AlWazirChat(
      id: _newId(),
      name: name,
      phone: phone,
      avatarPath: '',
      lastMessage: '',
      lastTime: null,
      unread: 0,
      pinned: false,
      muted: false,
      locked: false,
    );

    chats.insert(0, chat);

    messages[chat.id] = [];

    await _saveChats();
    await _saveMessages();

    notifyListeners();

    return chat;
  }

  Future<AlWazirChat> ensureChat({
    required String id,
    required String name,
    String phone = '',
  }) async {
    await ensureReady();

    final existing = chat(id);

    if (existing != null) {
      return existing;
    }

    final created = AlWazirChat(
      id: id,
      name: name,
      phone: phone,
      avatarPath: '',
      lastMessage: '',
      lastTime: null,
      unread: 0,
      pinned: false,
      muted: false,
      locked: false,
    );

    chats.insert(0, created);
    messages[id] = [];

    await _saveChats();
    await _saveMessages();

    notifyListeners();

    return created;
  }

  Future<AlWazirMessage> sendMessage({
    required String chatId,
    required String text,
    MessageType type = MessageType.text,
    String mediaPath = '',
    String replyToId = '',
    String replyText = '',
  }) async {
    await ensureReady();

    final now = DateTime.now();

    final message = AlWazirMessage(
      id: _newId(),
      chatId: chatId,
      senderId: account.id.isEmpty ? 'me' : account.id,
      text: text.trim(),
      mediaPath: mediaPath,
      type: type,
      status: MessageStatus.sent,
      createdAt: now,
      replyToId: replyToId,
      replyText: replyText,
      deletedForMe: false,
      deletedForEveryone: false,
      pinned: false,
      edited: false,
    );

    final list = chatMessages(chatId);
    list.add(message);

    final index = chats.indexWhere(
      (item) => item.id == chatId,
    );

    if (index >= 0) {
      final old = chats[index];

      chats[index] = old.copyWith(
        lastMessage: _messagePreview(message),
        lastTime: now,
      );
    }

    await _saveMessages();
    await _saveChats();

    notifyListeners();

    return message;
  }

  String _messagePreview(AlWazirMessage message) {
    if (message.deletedForEveryone) {
      return 'تم حذف هذه الرسالة';
    }

    switch (message.type) {
      case MessageType.image:
        return '📷 صورة';
      case MessageType.video:
        return '🎬 فيديو';
      case MessageType.file:
        return '📎 ملف';
      case MessageType.audio:
        return '🎤 رسالة صوتية';
      case MessageType.location:
        return '📍 الموقع';
      case MessageType.contact:
        return '👤 جهة اتصال';
      case MessageType.sticker:
        return '🎨 ملصق';
      case MessageType.gif:
        return 'GIF';
      case MessageType.text:
        return message.text;
    }
  }

  Future<void> editMessage(
    String chatId,
    String messageId,
    String text,
  ) async {
    await ensureReady();

    final list = chatMessages(chatId);

    final index = list.indexWhere(
      (item) => item.id == messageId,
    );

    if (index < 0) return;

    list[index] = list[index].copyWith(
      text: text.trim(),
      edited: true,
    );

    await _saveMessages();

    final chatIndex = chats.indexWhere(
      (item) => item.id == chatId,
    );

    if (chatIndex >= 0) {
      chats[chatIndex] = chats[chatIndex].copyWith(
        lastMessage: text.trim(),
      );

      await _saveChats();
    }

    notifyListeners();
  }

  Future<void> deleteForMe(
    String chatId,
    String messageId,
  ) async {
    await ensureReady();

    final list = chatMessages(chatId);

    final index = list.indexWhere(
      (item) => item.id == messageId,
    );

    if (index < 0) return;

    list[index] = list[index].copyWith(
      deletedForMe: true,
    );

    await _saveMessages();

    notifyListeners();
  }

  Future<void> deleteForEveryone(
    String chatId,
    String messageId,
  ) async {
    await ensureReady();

    final list = chatMessages(chatId);

    final index = list.indexWhere(
      (item) => item.id == messageId,
    );

    if (index < 0) return;

    list[index] = list[index].copyWith(
      text: '',
      mediaPath: '',
      deletedForEveryone: true,
    );

    await _saveMessages();

    notifyListeners();
  }

  Future<void> togglePinnedMessage(
    String chatId,
    String messageId,
  ) async {
    await ensureReady();

    final list = chatMessages(chatId);

    final index = list.indexWhere(
      (item) => item.id == messageId,
    );

    if (index < 0) return;

    final old = list[index];

    list[index] = old.copyWith(
      pinned: !old.pinned,
    );

    await _saveMessages();

    notifyListeners();
  }

  Future<void> markRead(String chatId) async {
    await ensureReady();

    final list = chatMessages(chatId);

    if (settings.readReceipts) {
      for (var i = 0; i < list.length; i++) {
        if (list[i].senderId != account.id) {
          list[i] = list[i].copyWith(
            status: MessageStatus.read,
          );
        }
      }
    }

    final index = chats.indexWhere(
      (item) => item.id == chatId,
    );

    if (index >= 0) {
      chats[index] = chats[index].copyWith(
        unread: 0,
      );
    }

    await _saveMessages();
    await _saveChats();

    notifyListeners();
  }

  Future<void> toggleChatFlag(
    String chatId, {
    bool? pinned,
    bool? muted,
    bool? locked,
  }) async {
    await ensureReady();

    final index = chats.indexWhere(
      (item) => item.id == chatId,
    );

    if (index < 0) return;

    final old = chats[index];

    chats[index] = old.copyWith(
      pinned: pinned,
      muted: muted,
      locked: locked,
    );

    await _saveChats();

    notifyListeners();
  }

  Future<AlWazirGroup> createGroup({
    required String name,
    List<String> members = const [],
  }) async {
    await ensureReady();

    final group = AlWazirGroup(
      id: _newId(),
      name: name.trim(),
      photoPath: '',
      members: List<String>.from(members),
      admins: account.id.isEmpty
          ? ['me']
          : [account.id],
      createdAt: DateTime.now(),
    );

    groups.insert(0, group);

    await _saveGroups();

    notifyListeners();

    return group;
  }

  Future<AlWazirStatus> createStatus({
    required String text,
    String mediaPath = '',
  }) async {
    await ensureReady();

    _removeExpiredStatuses();

    final status = AlWazirStatus(
      id: _newId(),
      ownerName: account.name.isEmpty
          ? 'أنا'
          : account.name,
      text: text.trim(),
      mediaPath: mediaPath,
      createdAt: DateTime.now(),
      views: 0,
    );

    statuses.insert(0, status);

    await _saveStatuses();

    notifyListeners();

    return status;
  }

  Future<void> deleteStatus(String id) async {
    await ensureReady();

    statuses.removeWhere(
      (status) => status.id == id,
    );

    await _saveStatuses();

    notifyListeners();
  }

  Future<void> addChannelPost({
    required String channelId,
    required String text,
  }) async {
    await ensureReady();

    final index = channels.indexWhere(
      (channel) => channel.id == channelId,
    );

    if (index < 0) return;

    final channel = channels[index];

    final post = AlWazirChannelPost(
      id: _newId(),
      text: text.trim(),
      createdAt: DateTime.now(),
      likes: 0,
    );

    channels[index] = channel.copyWith(
      posts: [
        post,
        ...channel.posts,
      ],
    );

    await _saveChannels();

    notifyListeners();
  }

  Future<void> followChannel(String channelId) async {
    await ensureReady();

    final index = channels.indexWhere(
      (channel) => channel.id == channelId,
    );

    if (index < 0) return;

    channels[index] = channels[index].copyWith(
      followed: !channels[index].followed,
    );

    await _saveChannels();

    notifyListeners();
  }

  Future<void> addCall({
    required String name,
    required CallType type,
    required CallDirection direction,
  }) async {
    await ensureReady();

    calls.insert(
      0,
      AlWazirCall(
        id: _newId(),
        name: name,
        type: type,
        direction: direction,
        createdAt: DateTime.now(),
      ),
    );

    await _saveCalls();

    notifyListeners();
  }

  Future<void> _saveChats() async {
    await _saveString(
      _chatsKey,
      jsonEncode(
        chats.map((e) => e.toMap()).toList(),
      ),
    );
  }

  Future<void> _saveMessages() async {
    final data = <String, dynamic>{};

    messages.forEach(
      (key, value) {
        data[key] = value.map((e) => e.toMap()).toList();
      },
    );

    await _saveString(
      _messagesKey,
      jsonEncode(data),
    );
  }

  Future<void> _saveGroups() async {
    await _saveString(
      _groupsKey,
      jsonEncode(
        groups.map((e) => e.toMap()).toList(),
      ),
    );
  }

  Future<void> _saveStatuses() async {
    await _saveString(
      _statusesKey,
      jsonEncode(
        statuses.map((e) => e.toMap()).toList(),
      ),
    );
  }

  Future<void> _saveChannels() async {
    await _saveString(
      _channelsKey,
      jsonEncode(
        channels.map((e) => e.toMap()).toList(),
      ),
    );
  }

  Future<void> _saveCalls() async {
    await _saveString(
      _callsKey,
      jsonEncode(
        calls.map((e) => e.toMap()).toList(),
      ),
    );
  }

  Future<void> clearLocalData() async {
    await ensureReady();

    chats.clear();
    messages.clear();
    groups.clear();
    statuses.clear();
    calls.clear();

    channels.clear();

    account = AlWazirAccount.empty();
    settings = AlWazirSettings.defaults();

    await _prefs?.remove(_accountKey);
    await _prefs?.remove(_settingsKey);
    await _prefs?.remove(_chatsKey);
    await _prefs?.remove(_messagesKey);
    await _prefs?.remove(_groupsKey);
    await _prefs?.remove(_statusesKey);
    await _prefs?.remove(_channelsKey);
    await _prefs?.remove(_callsKey);

    notifyListeners();
  }
}

/// ===============================================================
/// MAIN HOME SCREEN
/// ===============================================================

class MainHomeScreen extends StatefulWidget {
  final dynamic core;

  const MainHomeScreen({
    super.key,
    this.core,
  });

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int currentIndex = 0;

  static const Color gold = kGold;
  static const Color background = kBackground;
  static const Color panel = kPanel;

  late final AlWazirCore appCore;

  final List<String> titles = const [
    'الدردشات',
    'المجموعات',
    'المكالمات',
    'الحالة',
    'القنوات',
  ];

  @override
  void initState() {
    super.initState();

    appCore = widget.core is AlWazirCore
        ? widget.core as AlWazirCore
        : AlWazirCore.instance;

    appCore.init();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appCore,
      builder: (context, _) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: background,
            appBar: AppBar(
              backgroundColor: kAppBar,
              elevation: 0,
              centerTitle: true,
              title: Text(
                titles[currentIndex],
                style: const TextStyle(
                  color: gold,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  tooltip: 'الكاميرا',
                  onPressed: () {
                    _showInfo(
                      context,
                      'الكاميرا',
                      'سيتم ربط الكاميرا بالرسائل والحالة في خطوة الوسائط.',
                    );
                  },
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: gold,
                  ),
                ),
                IconButton(
                  tooltip: 'البحث',
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: _FahadSearchDelegate(appCore),
                    );
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  tooltip: 'الإعدادات',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SettingsPage(
                          core: appCore,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: IndexedStack(
              index: currentIndex,
              children: [
                ChatsPage(core: appCore),
                GroupsPage(core: appCore),
                CallsPage(core: appCore),
                StatusPage(core: appCore),
                ChannelsPage(core: appCore),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              backgroundColor: panel,
              selectedIndex: currentIndex,
              indicatorColor: const Color(0x33D4AF37),
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
                NavigationDestination(
                  icon: Icon(Icons.campaign_outlined),
                  selectedIcon: Icon(Icons.campaign),
                  label: 'القنوات',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// ===============================================================
/// CHATS
/// ===============================================================

class ChatsPage extends StatelessWidget {
  final AlWazirCore core;

  const ChatsPage({
    super.key,
    required this.core,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: core,
      builder: (context, _) {
        final chats = [...core.chats];

        chats.sort(
          (a, b) {
            if (a.pinned != b.pinned) {
              return a.pinned ? -1 : 1;
            }

            final aTime =
                a.lastTime ?? DateTime.fromMillisecondsSinceEpoch(0);

            final bTime =
                b.lastTime ?? DateTime.fromMillisecondsSinceEpoch(0);

            return bTime.compareTo(aTime);
          },
        );

        if (chats.isEmpty) {
          return _EmptyState(
            icon: Icons.chat_bubble_outline,
            title: 'لا توجد دردشات بعد',
            subtitle: 'ابدأ محادثة جديدة لتظهر هنا',
            actionText: 'دردشة جديدة',
            onAction: () {
              _showNewChatDialog(context, core);
            },
          );
        }

        return Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                90,
              ),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];

                return _ChatTile(
                  chat: chat,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatRoomScreen(
                          core: core,
                          chatId: chat.id,
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    _showChatOptions(
                      context,
                      core,
                      chat,
                    );
                  },
                );
              },
            ),
            Positioned(
              left: 20,
              bottom: 20,
              child: FloatingActionButton(
                backgroundColor: kGold,
                foregroundColor: Colors.black,
                onPressed: () {
                  _showNewChatDialog(context, core);
                },
                child: const Icon(Icons.chat),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// ===============================================================
/// CHAT TILE
/// ===============================================================

class _ChatTile extends StatelessWidget {
  final AlWazirChat chat;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ChatTile({
    required this.chat,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kPanel,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        leading: CircleAvatar(
          radius: 27,
          backgroundColor: kGold,
          child: Text(
            chat.name.isEmpty
                ? '?'
                : chat.name.characters.first,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                chat.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (chat.pinned)
              const Icon(
                Icons.push_pin,
                size: 16,
                color: kGold,
              ),
            if (chat.muted)
              const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.volume_off,
                  size: 16,
                  color: Colors.white54,
                ),
              ),
          ],
        ),
        subtitle: Text(
          chat.lastMessage.isEmpty
              ? 'ابدأ المحادثة'
              : chat.lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              chat.lastTime == null
                  ? ''
                  : _dayText(chat.lastTime!),
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
            if (chat.unread > 0) ...[
              const SizedBox(height: 5),
              CircleAvatar(
                radius: 10,
                backgroundColor: kGold,
                child: Text(
                  '${chat.unread}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ===============================================================
/// CHAT ROOM
/// ===============================================================

class ChatRoomScreen extends StatefulWidget {
  final AlWazirCore core;
  final String chatId;

  const ChatRoomScreen({
    super.key,
    required this.core,
    required this.chatId,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController messageController =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();

  AlWazirMessage? replyMessage;

  @override
  void initState() {
    super.initState();

    widget.core.markRead(widget.chatId);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToBottom(),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!scrollController.hasClients) return;

    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Future<void> _send() async {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    await widget.core.sendMessage(
      chatId: widget.chatId,
      text: text,
      replyToId: replyMessage?.id ?? '',
      replyText: replyMessage?.text ?? '',
    );

    messageController.clear();

    setState(() {
      replyMessage = null;
    });

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToBottom(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chat = widget.core.chat(widget.chatId);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          backgroundColor: kAppBar,
          titleSpacing: 0,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: kGold,
                foregroundColor: Colors.black,
                child: Text(
                  chat?.name.characters.first ?? '?',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  chat?.name ?? 'محادثة',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                _showChatRoomOptions(context);
              },
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: AnimatedBuilder(
          animation: widget.core,
          builder: (context, _) {
            final list = widget.core
                .chatMessages(widget.chatId)
                .where((message) => !message.deletedForMe)
                .toList();

            return Column(
              children: [
                Expanded(
                  child: list.isEmpty
                      ? const _EmptyState(
                          icon: Icons.forum_outlined,
                          title: 'لا توجد رسائل',
                          subtitle:
                              'اكتب أول رسالة لبدء المحادثة',
                        )
                      : ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(12),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final message = list[index];

                            return _MessageBubble(
                              message: message,
                              onReply: () {
                                setState(() {
                                  replyMessage = message;
                                });
                              },
                              onDeleteMe: () {
                                widget.core.deleteForMe(
                                  widget.chatId,
                                  message.id,
                                );
                              },
                              onDeleteEveryone: () {
                                widget.core.deleteForEveryone(
                                  widget.chatId,
                                  message.id,
                                );
                              },
                              onEdit: () {
                                _editMessage(
                                  context,
                                  message,
                                );
                              },
                              onPin: () {
                                widget.core.togglePinnedMessage(
                                  widget.chatId,
                                  message.id,
                                );
                              },
                            );
                          },
                        ),
                ),
                if (replyMessage != null)
                  Container(
                    width: double.infinity,
                    color: kPanel,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.reply,
                          color: kGold,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            replyMessage!.text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              replyMessage = null;
                            });
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                _Composer(
                  controller: messageController,
                  onSend: _send,
                  onAttachment: () {
                    _showAttachmentSheet(context);
                  },
                  onVoice: () {
                    _showVoiceInfo(context);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _editMessage(
    BuildContext context,
    AlWazirMessage message,
  ) {
    final controller = TextEditingController(
      text: message.text,
    );

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kPanel,
          title: const Text('تعديل الرسالة'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'الرسالة',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kGold,
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                final value = controller.text.trim();

                if (value.isNotEmpty) {
                  await widget.core.editMessage(
                    widget.chatId,
                    message.id,
                    value,
                  );
                }

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  void _showChatRoomOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: kPanel,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.search,
                  color: kGold,
                ),
                title: const Text('البحث في المحادثة'),
                onTap: () {
                  Navigator.pop(context);
                  showSearch(
                    context: context,
                    delegate: _ChatSearchDelegate(
                      widget.core,
                      widget.chatId,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.push_pin,
                  color: kGold,
                ),
                title: const Text('تثبيت المحادثة'),
                onTap: () async {
                  Navigator.pop(context);

                  final chat = widget.core.chat(
                    widget.chatId,
                  );

                  if (chat != null) {
                    await widget.core.toggleChatFlag(
                      widget.chatId,
                      pinned: !chat.pinned,
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.volume_off,
                  color: kGold,
                ),
                title: const Text('كتم الإشعارات'),
                onTap: () async {
                  Navigator.pop(context);

                  final chat = widget.core.chat(
                    widget.chatId,
                  );

                  if (chat != null) {
                    await widget.core.toggleChatFlag(
                      widget.chatId,
                      muted: !chat.muted,
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.lock_outline,
                  color: kGold,
                ),
                title: const Text('قفل المحادثة'),
                onTap: () async {
                  Navigator.pop(context);

                  final chat = widget.core.chat(
                    widget.chatId,
                  );

                  if (chat != null) {
                    await widget.core.toggleChatFlag(
                      widget.chatId,
                      locked: !chat.locked,
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAttachmentSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: kPanel,
      builder: (context) {
        final items = [
          _AttachItem(
            icon: Icons.photo,
            label: 'المعرض',
            onTap: () {
              Navigator.pop(context);
              _showInfo(
                context,
                'المعرض',
                'ربط image_picker سيتم في خطوة الوسائط الحقيقية.',
              );
            },
          ),
          _AttachItem(
            icon: Icons.camera_alt,
            label: 'الكاميرا',
            onTap: () {
              Navigator.pop(context);
              _showInfo(
                context,
                'الكاميرا',
                'ربط الكاميرا سيتم في خطوة الوسائط الحقيقية.',
              );
            },
          ),
          _AttachItem(
            icon: Icons.videocam,
            label: 'فيديو',
            onTap: () {
              Navigator.pop(context);
              _showInfo(
                context,
                'الفيديو',
                'سيتم ربط الفيديو وحفظ مساره محليًا.',
              );
            },
          ),
          _AttachItem(
            icon: Icons.insert_drive_file,
            label: 'ملف',
            onTap: () {
              Navigator.pop(context);
              _showInfo(
                context,
                'الملفات',
                'سيتم ربط file_picker في خطوة الوسائط.',
              );
            },
          ),
          _AttachItem(
            icon: Icons.location_on,
            label: 'الموقع',
            onTap: () {
              Navigator.pop(context);
              _showInfo(
                context,
                'الموقع',
                'سيتم ربط الموقع الجغرافي في خطوة المشاركة.',
              );
            },
          ),
          _AttachItem(
            icon: Icons.person,
            label: 'جهة اتصال',
            onTap: () {
              Navigator.pop(context);
              _showInfo(
                context,
                'جهة اتصال',
                'سيتم ربط جهات الاتصال في خطوة المزامنة.',
              );
            },
          ),
          _AttachItem(
            icon: Icons.gif_box,
            label: 'GIF',
            onTap: () {
              Navigator.pop(context);
              _showInfo(
                context,
                'GIF',
                'سيتم ربط GIF في خطوة الوسائط.',
              );
            },
          ),
          _AttachItem(
            icon: Icons.emoji_emotions,
            label: 'ملصق',
            onTap: () {
              Navigator.pop(context);
              _showInfo(
                context,
                'الملصقات',
                'سيتم ربط الملصقات في خطوة واجهة الرسائل.',
              );
            },
          ),
        ];

        return SafeArea(
          child: GridView.count(
            shrinkWrap: true,
            padding: const EdgeInsets.all(18),
            crossAxisCount: 4,
            children: items,
          ),
        );
      },
    );
  }

  void _showVoiceInfo(BuildContext context) {
    _showInfo(
      context,
      '🎤 الرسائل الصوتية',
      'واجهة التسجيل جاهزة للربط مع record. لن نعتبرها تسجيلًا حقيقيًا حتى يتم ربط API التسجيل وحفظ الملف.',
    );
  }
}

/// ===============================================================
/// MESSAGE BUBBLE
/// ===============================================================

class _MessageBubble extends StatelessWidget {
  final AlWazirMessage message;
  final VoidCallback onReply;
  final VoidCallback onDeleteMe;
  final VoidCallback onDeleteEveryone;
  final VoidCallback onEdit;
  final VoidCallback onPin;

  const _MessageBubble({
    required this.message,
    required this.onReply,
    required this.onDeleteMe,
    required this.onDeleteEveryone,
    required this.onEdit,
    required this.onPin,
  });

  @override
  Widget build(BuildContext context) {
    final mine = message.senderId == 'me';

    return Align(
      alignment:
          mine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () {
          _showMessageMenu(context);
        },
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * .78,
          ),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.fromLTRB(
            12,
            8,
            12,
            7,
          ),
          decoration: BoxDecoration(
            color: mine ? const Color(0xFF315044) : kPanel,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(
                mine ? 16 : 4,
              ),
              bottomRight: Radius.circular(
                mine ? 4 : 16,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (message.pinned)
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.push_pin,
                      size: 13,
                      color: kGold,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'مثبتة',
                      style: TextStyle(
                        color: kGold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              if (message.replyText.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(7),
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    message.replyText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              if (message.deletedForEveryone)
                const Text(
                  'تم حذف هذه الرسالة',
                  style: TextStyle(
                    color: Colors.white54,
                    fontStyle: FontStyle.italic,
                  ),
                )
              else if (message.type == MessageType.text)
                Text(
                  message.text,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _messageIcon(message.type),
                      color: kGold,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      _messageTypeText(message.type),
                    ),
                  ],
                ),
              const SizedBox(height: 3),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.edited)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Text(
                        'معدلة',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  Text(
                    _dateTimeText(message.createdAt),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                  if (mine) ...[
                    const SizedBox(width: 4),
                    Icon(
                      message.status == MessageStatus.read
                          ? Icons.done_all
                          : Icons.done,
                      size: 15,
                      color:
                          message.status == MessageStatus.read
                              ? kGold
                              : Colors.white54,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _messageIcon(MessageType type) {
    switch (type) {
      case MessageType.image:
        return Icons.photo;
      case MessageType.video:
        return Icons.videocam;
      case MessageType.file:
        return Icons.insert_drive_file;
      case MessageType.audio:
        return Icons.mic;
      case MessageType.location:
        return Icons.location_on;
      case MessageType.contact:
        return Icons.person;
      case MessageType.sticker:
        return Icons.emoji_emotions;
      case MessageType.gif:
        return Icons.gif_box;
      case MessageType.text:
        return Icons.message;
    }
  }

  String _messageTypeText(MessageType type) {
    switch (type) {
      case MessageType.image:
        return 'صورة';
      case MessageType.video:
        return 'فيديو';
      case MessageType.file:
        return 'ملف';
      case MessageType.audio:
        return 'رسالة صوتية';
      case MessageType.location:
        return 'الموقع';
      case MessageType.contact:
        return 'جهة اتصال';
      case MessageType.sticker:
        return 'ملصق';
      case MessageType.gif:
        return 'GIF';
      case MessageType.text:
        return '';
    }
  }

  void _showMessageMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: kPanel,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.reply,
                  color: kGold,
                ),
                title: const Text('رد'),
                onTap: () {
                  Navigator.pop(context);
                  onReply();
                },
              ),
              if (message.type == MessageType.text &&
                  !message.deletedForEveryone)
                ListTile(
                  leading: const Icon(
                    Icons.edit,
                    color: kGold,
                  ),
                  title: const Text('تعديل'),
                  onTap: () {
                    Navigator.pop(context);
                    onEdit();
                  },
                ),
              ListTile(
                leading: Icon(
                  message.pinned
                      ? Icons.push_pin_outlined
                      : Icons.push_pin,
                  color: kGold,
                ),
                title: Text(
                  message.pinned
                      ? 'إلغاء التثبيت'
                      : 'تثبيت',
                ),
                onTap: () {
                  Navigator.pop(context);
                  onPin();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
                title: const Text('حذف لدي'),
                onTap: () {
                  Navigator.pop(context);
                  onDeleteMe();
                },
              ),
              if (message.senderId == 'me')
                ListTile(
                  leading: const Icon(
                    Icons.delete_forever,
                    color: Colors.redAccent,
                  ),
                  title: const Text('حذف لدى الجميع'),
                  onTap: () {
                    Navigator.pop(context);
                    onDeleteEveryone();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

/// ===============================================================
/// COMPOSER
/// ===============================================================

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttachment;
  final VoidCallback onVoice;

  const _Composer({
    required this.controller,
    required this.onSend,
    required this.onAttachment,
    required this.onVoice,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: kAppBar,
        padding: const EdgeInsets.fromLTRB(
          8,
          7,
          8,
          7,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: onAttachment,
              icon: const Icon(
                Icons.attach_file,
                color: kGold,
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                textDirection: TextDirection.rtl,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'اكتب رسالة',
                  filled: true,
                  fillColor: kPanel,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.white54,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _showInfo(
                        context,
                        'GIF والملصقات',
                        'ستتم إضافة لوحة GIF والملصقات في خطوة واجهة الوسائط.',
                      );
                    },
                    icon: const Icon(
                      Icons.gif_box_outlined,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                final hasText = value.text.trim().isNotEmpty;

                return CircleAvatar(
                  backgroundColor: kGold,
                  foregroundColor: Colors.black,
                  child: IconButton(
                    onPressed: hasText ? onSend : onVoice,
                    icon: Icon(
                      hasText ? Icons.send : Icons.mic,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// ===============================================================
/// ATTACHMENT ITEM
/// ===============================================================

class _AttachItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AttachItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: kGold,
            foregroundColor: Colors.black,
            child: Icon(icon),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// ===============================================================
/// GROUPS
/// ===============================================================

class GroupsPage extends StatelessWidget {
  final AlWazirCore core;

  const GroupsPage({
    super.key,
    required this.core,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: core,
      builder: (context, _) {
        if (core.groups.isEmpty) {
          return _EmptyState(
            icon: Icons.groups_outlined,
            title: 'لا توجد مجموعات',
            subtitle: 'أنشئ أول مجموعة في الفهد',
            actionText: 'إنشاء مجموعة',
            onAction: () {
              _showCreateGroupDialog(context, core);
            },
          );
        }

        return Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                90,
              ),
              itemCount: core.groups.length,
              itemBuilder: (context, index) {
                final group = core.groups[index];

                return _GroupTile(
                  group: group,
                  onTap: () {
                    _showGroupInfo(context, group);
                  },
                );
              },
            ),
            Positioned(
              left: 20,
              bottom: 20,
              child: FloatingActionButton(
                backgroundColor: kGold,
                foregroundColor: Colors.black,
                onPressed: () {
                  _showCreateGroupDialog(context, core);
                },
                child: const Icon(Icons.group_add),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GroupTile extends StatelessWidget {
  final AlWazirGroup group;
  final VoidCallback onTap;

  const _GroupTile({
    required this.group,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kPanel,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(
          backgroundColor: kGold,
          foregroundColor: Colors.black,
          child: Icon(Icons.groups),
        ),
        title: Text(
          group.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${group.members.length} عضو',
        ),
        trailing: const Icon(
          Icons.chevron_left,
          color: kGold,
        ),
      ),
    );
  }
}

/// ===============================================================
/// CALLS
/// ===============================================================

class CallsPage extends StatelessWidget {
  final AlWazirCore core;

  const CallsPage({
    super.key,
    required this.core,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: core,
      builder: (context, _) {
        if (core.calls.isEmpty) {
          return _EmptyState(
            icon: Icons.call_outlined,
            title: 'لا يوجد سجل مكالمات',
            subtitle: 'سيظهر سجل المكالمات هنا بعد إجراء المكالمات',
            actionText: 'اختبار الواجهة',
            onAction: () async {
              await core.addCall(
                name: 'محمد',
                type: CallType.voice,
                direction: CallDirection.outgoing,
              );
            },
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: core.calls.length,
          itemBuilder: (context, index) {
            final call = core.calls[index];

            return _CallTile(
              call: call,
              onCall: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CallScreen(
                      core: core,
                      name: call.name,
                      type: call.type,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _CallTile extends StatelessWidget {
  final AlWazirCall call;
  final VoidCallback onCall;

  const _CallTile({
    required this.call,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    final missed =
        call.direction == CallDirection.missed;

    final incoming =
        call.direction == CallDirection.incoming;

    return Card(
      color: kPanel,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: kGold,
          foregroundColor: Colors.black,
          child: Icon(
            missed
                ? Icons.call_missed
                : call.type == CallType.video
                    ? Icons.videocam
                    : Icons.call,
          ),
        ),
        title: Text(call.name),
        subtitle: Row(
          children: [
            Icon(
              incoming
                  ? Icons.call_received
                  : Icons.call_made,
              size: 15,
              color:
                  missed ? Colors.redAccent : kGold,
            ),
            const SizedBox(width: 5),
            Text(
              call.type == CallType.video
                  ? 'مكالمة فيديو'
                  : 'مكالمة صوتية',
            ),
            const SizedBox(width: 8),
            Text(
              _relativeTime(call.createdAt),
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: onCall,
          icon: Icon(
            call.type == CallType.video
                ? Icons.videocam
                : Icons.call,
            color: kGold,
          ),
        ),
      ),
    );
  }
}

/// ===============================================================
/// STATUS
/// ===============================================================

class StatusPage extends StatelessWidget {
  final AlWazirCore core;

  const StatusPage({
    super.key,
    required this.core,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: core,
      builder: (context, _) {
        final statuses =
            core.statuses.where((e) => !e.expired).toList();

        return Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                90,
              ),
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 55,
                    height: 55,
                    decoration: const BoxDecoration(
                      color: kGold,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
                  title: Text(
                    core.account.name.isEmpty
                        ? 'حالتي'
                        : core.account.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'إضافة حالة جديدة',
                  ),
                  onTap: () {
                    _showStatusDialog(context, core);
                  },
                ),
                const Divider(),
                const Text(
                  'الحالات الأخيرة',
                  style: TextStyle(
                    color: kGold,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 12),
                if (statuses.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 35),
                    child: Center(
                      child: Text(
                        'لا توجد حالات منشورة حاليًا',
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  )
                else
                  ...statuses.map(
                    (status) => _StatusTile(
                      status: status,
                      onTap: () {
                        _showStatusView(
                          context,
                          status,
                        );
                      },
                      onDelete: () {
                        core.deleteStatus(status.id);
                      },
                    ),
                  ),
              ],
            ),
            Positioned(
              left: 20,
              bottom: 20,
              child: FloatingActionButton(
                backgroundColor: kGold,
                foregroundColor: Colors.black,
                onPressed: () {
                  _showStatusDialog(context, core);
                },
                child: const Icon(Icons.camera_alt),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatusTile extends StatelessWidget {
  final AlWazirStatus status;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _StatusTile({
    required this.status,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      onLongPress: onDelete,
      leading: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: kGold,
            width: 2,
          ),
        ),
        child: const CircleAvatar(
          backgroundColor: kPanel,
          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        status.ownerName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '${_relativeTime(status.createdAt)} • ${status.views} مشاهدة',
      ),
      trailing: const Icon(
        Icons.chevron_left,
        color: kGold,
      ),
    );
  }
}

/// ===============================================================
/// CHANNELS
/// ===============================================================

class ChannelsPage extends StatelessWidget {
  final AlWazirCore core;

  const ChannelsPage({
    super.key,
    required this.core,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: core,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...core.channels.map(
              (channel) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ChannelTile(
                  channel: channel,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChannelScreen(
                          core: core,
                          channelId: channel.id,
                        ),
                      ),
                    );
                  },
                  onFollow: () {
                    core.followChannel(channel.id);
                  },
                ),
              ),
            ),
            Card(
              color: kPanel,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: kGold,
                  foregroundColor: Colors.black,
                  child: Icon(Icons.wifi_tethering),
                ),
                title: const Text(
                  'الاتصال القريب',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'البحث عن أجهزة الفهد القريبة',
                ),
                trailing: const Icon(
                  Icons.chevron_left,
                  color: kGold,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NearbyScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ChannelTile extends StatelessWidget {
  final AlWazirChannel channel;
  final VoidCallback onTap;
  final VoidCallback onFollow;

  const _ChannelTile({
    required this.channel,
    required this.onTap,
    required this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kPanel,
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(
          backgroundColor: kGold,
          foregroundColor: Colors.black,
          child: Icon(Icons.pets),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                channel.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (channel.verified) ...[
              const SizedBox(width: 5),
              const Icon(
                Icons.verified,
                size: 17,
                color: kGold,
              ),
            ],
          ],
        ),
        subtitle: Text(
          channel.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: TextButton(
          onPressed: onFollow,
          child: Text(
            channel.followed
                ? 'متابَع'
                : 'متابعة',
            style: const TextStyle(
              color: kGold,
            ),
          ),
        ),
      ),
    );
  }
}

/// ===============================================================
/// CHANNEL SCREEN
/// ===============================================================

class ChannelScreen extends StatelessWidget {
  final AlWazirCore core;
  final String channelId;

  const ChannelScreen({
    super.key,
    required this.core,
    required this.channelId,
  });

  @override
  Widget build(BuildContext context) {
    final channel = core.channels.firstWhere(
      (item) => item.id == channelId,
      orElse: () => const AlWazirChannel(
        id: '',
        name: 'القناة',
        description: '',
        verified: false,
        followed: false,
        posts: [],
      ),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          backgroundColor: kAppBar,
          title: Text(channel.name),
          actions: [
            IconButton(
              onPressed: () {
                core.followChannel(channel.id);
              },
              icon: Icon(
                channel.followed
                    ? Icons.notifications_active
                    : Icons.notifications_none,
                color: kGold,
              ),
            ),
          ],
        ),
        floatingActionButton: channel.id.isEmpty
            ? null
            : FloatingActionButton(
                backgroundColor: kGold,
                foregroundColor: Colors.black,
                onPressed: () {
                  _showChannelPostDialog(
                    context,
                    core,
                    channel.id,
                  );
                },
                child: const Icon(Icons.add),
              ),
        body: AnimatedBuilder(
          animation: core,
          builder: (context, _) {
            final current = core.channels.firstWhere(
              (item) => item.id == channelId,
              orElse: () => channel,
            );

            if (current.posts.isEmpty) {
              return const _EmptyState(
                icon: Icons.campaign_outlined,
                title: 'لا توجد منشورات',
                subtitle: 'لم يتم نشر أي منشور بعد',
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: current.posts.length,
              itemBuilder: (context, index) {
                final post = current.posts[index];

                return Card(
                  color: kPanel,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundColor: kGold,
                              foregroundColor: Colors.black,
                              child: Icon(Icons.pets),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                current.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              _relativeTime(post.createdAt),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          post.text,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.favorite_border,
                              color: kGold,
                            ),
                            const SizedBox(width: 5),
                            Text('${post.likes}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// ===============================================================
/// SETTINGS
/// ===============================================================

class SettingsPage extends StatelessWidget {
  final AlWazirCore core;

  const SettingsPage({
    super.key,
    required this.core,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          backgroundColor: kAppBar,
          title: const Text('الإعدادات'),
        ),
        body: AnimatedBuilder(
          animation: core,
          builder: (context, _) {
            final account = core.account;
            final settings = core.settings;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  color: kPanel,
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 30,
                      backgroundColor: kGold,
                      foregroundColor: Colors.black,
                      child: Icon(Icons.person),
                    ),
                    title: Text(
                      account.name.isEmpty
                          ? 'الملف الشخصي'
                          : account.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    subtitle: Text(
                      account.phone.isEmpty
                          ? 'أضف رقم الهاتف'
                          : '${account.countryCode} ${account.phone}',
                    ),
                    trailing: const Icon(
                      Icons.chevron_left,
                      color: kGold,
                    ),
                    onTap: () {
                      _showProfileDialog(context, core);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                _settingsSectionTitle('الحساب'),
                _SettingsTile(
                  icon: Icons.person_outline,
                  title: 'الملف الشخصي',
                  subtitle: 'الاسم ورقم الهاتف',
                  onTap: () {
                    _showProfileDialog(context, core);
                  },
                ),
                _SettingsTile(
                  icon: Icons.language,
                  title: 'اللغة',
                  subtitle: settings.language,
                  onTap: () {
                    _showLanguageDialog(context, core);
                  },
                ),
                _settingsSectionTitle('الخصوصية والأمان'),
                _SwitchTile(
                  icon: Icons.done_all,
                  title: 'إيصالات القراءة',
                  value: settings.readReceipts,
                  onChanged: (value) {
                    core.updateSettings(
                      settings.copyWith(
                        readReceipts: value,
                      ),
                    );
                  },
                ),
                _SwitchTile(
                  icon: Icons.visibility,
                  title: 'آخر ظهور',
                  value: settings.lastSeenEnabled,
                  onChanged: (value) {
                    core.updateSettings(
                      settings.copyWith(
                        lastSeenEnabled: value,
                      ),
                    );
                  },
                ),
                _SwitchTile(
                  icon: Icons.lock_outline,
                  title: 'قفل التطبيق',
                  value: settings.appLockEnabled,
                  onChanged: (value) {
                    core.updateSettings(
                      settings.copyWith(
                        appLockEnabled: value,
                      ),
                    );
                  },
                ),
                _SwitchTile(
                  icon: Icons.chat_lock_outlined,
                  title: 'قفل المحادثات',
                  value: settings.chatLockEnabled,
                  onChanged: (value) {
                    core.updateSettings(
                      settings.copyWith(
                        chatLockEnabled: value,
                      ),
                    );
                  },
                ),
                _SwitchTile(
                  icon: Icons.security,
                  title: 'التحقق بخطوتين',
                  value: settings.twoStepEnabled,
                  onChanged: (value) {
                    core.updateSettings(
                      settings.copyWith(
                        twoStepEnabled: value,
                      ),
                    );
                  },
                ),
                _settingsSectionTitle('الإشعارات'),
                _SwitchTile(
                  icon: Icons.notifications_outlined,
                  title: 'الإشعارات',
                  value: settings.notificationsEnabled,
                  onChanged: (value) {
                    core.updateSettings(
                      settings.copyWith(
                        notificationsEnabled: value,
                      ),
                    );
                  },
                ),
                _settingsSectionTitle('البيانات'),
                _SettingsTile(
                  icon: Icons.storage_outlined,
                  title: 'التخزين',
                  subtitle:
                      '${core.chats.length} دردشة • ${core.messages.length} محادثة محفوظة',
                  onTap: () {
                    _showStorageInfo(context, core);
                  },
                ),
                _SettingsTile(
                  icon: Icons.sync,
                  title: 'المزامنة',
                  subtitle: 'حالة المزامنة المحلية',
                  onTap: () {
                    _showInfo(
                      context,
                      'المزامنة',
                      'النواة المحلية تحفظ البيانات حاليًا. سيتم ربط Firebase والمزامنة السحابية في المرحلة التالية.',
                    );
                  },
                ),
                _SettingsTile(
                  icon: Icons.devices,
                  title: 'الأجهزة المرتبطة',
                  subtitle: 'إدارة الأجهزة المرتبطة بالحساب',
                  onTap: () {
                    _showInfo(
                      context,
                      'الأجهزة المرتبطة',
                      'واجهة إدارة الأجهزة جاهزة للربط بخدمة الحساب والمزامنة.',
                    );
                  },
                ),
                const SizedBox(height: 15),
                Card(
                  color: const Color(0xFF351D22),
                  child: ListTile(
                    leading: const Icon(
                      Icons.delete_forever,
                      color: Colors.redAccent,
                    ),
                    title: const Text(
                      'مسح البيانات المحلية',
                    ),
                    subtitle: const Text(
                      'سيحذف الحساب والدردشات والمجموعات والحالات والسجل من الجهاز',
                    ),
                    onTap: () {
                      _confirmClearData(
                        context,
                        core,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _settingsSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 18,
        bottom: 8,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: kGold,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kPanel,
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: kGold,
        ),
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white54,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_left,
          color: Colors.white54,
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kPanel,
      margin: const EdgeInsets.only(bottom: 6),
      child: SwitchListTile(
        secondary: Icon(
          icon,
          color: kGold,
        ),
        title: Text(title),
        value: value,
        activeThumbColor: kGold,
        onChanged: onChanged,
      ),
    );
  }
}

/// ===============================================================
/// CALL SCREEN
/// ===============================================================

class CallScreen extends StatefulWidget {
  final AlWazirCore core;
  final String name;
  final CallType type;

  const CallScreen({
    super.key,
    required this.core,
    required this.name,
    required this.type,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool speaker = false;
  bool muted = false;
  bool camera = true;

  @override
  void initState() {
    super.initState();

    widget.core.addCall(
      name: widget.name,
      type: widget.type,
      direction: CallDirection.outgoing,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              CircleAvatar(
                radius: 55,
                backgroundColor: kGold,
                foregroundColor: Colors.black,
                child: Text(
                  widget.name.characters.first,
                  style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.type == CallType.video
                    ? 'مكالمة فيديو'
                    : 'مكالمة صوتية',
                style: const TextStyle(
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'جاري الاتصال...',
                style: TextStyle(
                  color: kGold,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  _CallButton(
                    icon: muted
                        ? Icons.mic_off
                        : Icons.mic,
                    active: muted,
                    onTap: () {
                      setState(() {
                        muted = !muted;
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                  _CallButton(
                    icon: Icons.call_end,
                    active: true,
                    end: true,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 20),
                  _CallButton(
                    icon: speaker
                        ? Icons.volume_up
                        : Icons.volume_down,
                    active: speaker,
                    onTap: () {
                      setState(() {
                        speaker = !speaker;
                      });
                    },
                  ),
                  if (widget.type == CallType.video) ...[
                    const SizedBox(width: 20),
                    _CallButton(
                      icon: camera
                          ? Icons.videocam
                          : Icons.videocam_off,
                      active: !camera,
                      onTap: () {
                        setState(() {
                          camera = !camera;
                        });
                      },
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  final IconData icon;
  final bool active;
  final bool end;
  final VoidCallback onTap;

  const _CallButton({
    required this.icon,
    required this.active,
    required this.onTap,
    this.end = false,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 27,
      backgroundColor:
          end ? Colors.redAccent : kPanel,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: end || active
              ? Colors.white
              : kGold,
        ),
      ),
    );
  }
}

/// ===============================================================
/// NEARBY SCREEN
///
/// الواجهة هنا حقيقية من ناحية حالة التطبيق، لكن الاتصال
/// الفعلي Bluetooth/Wi-Fi Direct لم نضع له simulation.
/// سيتم ربط nearby_connections في المرحلة التالية.
/// ===============================================================

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({
    super.key,
  });

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  bool searching = false;

  void _toggleSearch() {
    setState(() {
      searching = !searching;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          backgroundColor: kAppBar,
          title: const Text('الاتصال القريب'),
          actions: [
            IconButton(
              onPressed: _toggleSearch,
              icon: Icon(
                searching
                    ? Icons.stop_circle_outlined
                    : Icons.search,
                color: kGold,
              ),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 500),
                  width: searching ? 150 : 120,
                  height: searching ? 150 : 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: kGold,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    searching
                        ? Icons.wifi_tethering
                        : Icons.bluetooth,
                    color: kGold,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  searching
                      ? 'جاري البحث عن أجهزة الفهد...'
                      : 'الاتصال القريب مغلق',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'سيتم هنا ربط Bluetooth و Wi-Fi Direct للمراسلة بين الأجهزة القريبة بدون إنترنت.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 13,
                    ),
                  ),
                  onPressed: _toggleSearch,
                  icon: Icon(
                    searching
                        ? Icons.stop
                        : Icons.radar,
                  ),
                  label: Text(
                    searching
                        ? 'إيقاف البحث'
                        : 'بدء البحث',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ===============================================================
/// SEARCH
/// ===============================================================

class _FahadSearchDelegate
    extends SearchDelegate<String> {
  final AlWazirCore core;

  _FahadSearchDelegate(this.core);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: kBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: kAppBar,
      ),
      inputDecorationTheme:
          const InputDecorationTheme(
        hintStyle: TextStyle(
          color: Colors.white54,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _build();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _build();
  }

  Widget _build() {
    final value = query.trim().toLowerCase();

    if (value.isEmpty) {
      return const _EmptyState(
        icon: Icons.search,
        title: 'ابحث في الفهد',
        subtitle: 'الدردشات والمجموعات والقنوات',
      );
    }

    final chats = core.chats.where(
      (chat) =>
          chat.name.toLowerCase().contains(value) ||
          chat.phone.toLowerCase().contains(value) ||
          chat.lastMessage.toLowerCase().contains(value),
    );

    final groups = core.groups.where(
      (group) =>
          group.name.toLowerCase().contains(value),
    );

    final channels = core.channels.where(
      (channel) =>
          channel.name.toLowerCase().contains(value) ||
          channel.description
              .toLowerCase()
              .contains(value),
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...chats.map(
          (chat) => ListTile(
            leading: const CircleAvatar(
              backgroundColor: kGold,
              foregroundColor: Colors.black,
              child: Icon(Icons.person),
            ),
            title: Text(chat.name),
            subtitle: Text(chat.lastMessage),
          ),
        ),
        ...groups.map(
          (group) => ListTile(
            leading: const CircleAvatar(
              backgroundColor: kGold,
              foregroundColor: Colors.black,
              child: Icon(Icons.groups),
            ),
            title: Text(group.name),
            subtitle: const Text('مجموعة'),
          ),
        ),
        ...channels.map(
          (channel) => ListTile(
            leading: const CircleAvatar(
              backgroundColor: kGold,
              foregroundColor: Colors.black,
              child: Icon(Icons.campaign),
            ),
            title: Text(channel.name),
            subtitle: Text(channel.description),
          ),
        ),
        if (!chats.any((_) => true) &&
            !groups.any((_) => true) &&
            !channels.any((_) => true))
          const _EmptyState(
            icon: Icons.search_off,
            title: 'لا توجد نتائج',
            subtitle: 'جرّب كلمة بحث أخرى',
          ),
      ],
    );
  }
}

/// ===============================================================
/// CHAT SEARCH
/// ===============================================================

class _ChatSearchDelegate
    extends SearchDelegate<String> {
  final AlWazirCore core;
  final String chatId;

  _ChatSearchDelegate(
    this.core,
    this.chatId,
  );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: kBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: kAppBar,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _results();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _results();
  }

  Widget _results() {
    final value = query.trim().toLowerCase();

    final messages = core
        .chatMessages(chatId)
        .where(
          (message) =>
              value.isEmpty ||
              message.text.toLowerCase().contains(value),
        )
        .toList();

    if (messages.isEmpty) {
      return const _EmptyState(
        icon: Icons.search_off,
        title: 'لا توجد رسائل',
        subtitle: 'لم يتم العثور على نتيجة',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];

        return Card(
          color: kPanel,
          child: ListTile(
            title: Text(
              message.deletedForEveryone
                  ? 'تم حذف الرسالة'
                  : message.text,
            ),
            subtitle: Text(
              _dateTimeText(message.createdAt),
            ),
          ),
        );
      },
    );
  }
}

/// ===============================================================
/// EMPTY STATE
/// ===============================================================

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: kPanel,
              child: Icon(
                icon,
                size: 42,
                color: kGold,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white54,
              ),
            ),
            if (actionText != null &&
                onAction != null) ...[
              const SizedBox(height: 22),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGold,
                  foregroundColor: Colors.black,
                ),
                onPressed: onAction,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ===============================================================
/// DIALOGS / HELPERS
/// ===============================================================

Future<void> _showNewChatDialog(
  BuildContext context,
  AlWazirCore core,
) async {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  await showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: kPanel,
        title: const Text('دردشة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'اسم الشخص',
              ),
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kGold,
              foregroundColor: Colors.black,
            ),
            onPressed: () async {
              final name =
                  nameController.text.trim();

              if (name.isEmpty) return;

              final chat = await core.createChat(
                name: name,
                phone: phoneController.text.trim(),
              );

              if (context.mounted) {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatRoomScreen(
                      core: core,
                      chatId: chat.id,
                    ),
                  ),
                );
              }
            },
            child: const Text('بدء'),
          ),
        ],
      );
    },
  );
}

Future<void> _showChatOptions(
  BuildContext context,
  AlWazirCore core,
  AlWazirChat chat,
) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: kPanel,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.push_pin,
                color: kGold,
              ),
              title: Text(
                chat.pinned
                    ? 'إلغاء تثبيت'
                    : 'تثبيت',
              ),
              onTap: () async {
                await core.toggleChatFlag(
                  chat.id,
                  pinned: !chat.pinned,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.volume_off,
                color: kGold,
              ),
              title: Text(
                chat.muted
                    ? 'إلغاء الكتم'
                    : 'كتم',
              ),
              onTap: () async {
                await core.toggleChatFlag(
                  chat.id,
                  muted: !chat.muted,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.lock_outline,
                color: kGold,
              ),
              title: Text(
                chat.locked
                    ? 'إلغاء قفل المحادثة'
                    : 'قفل المحادثة',
              ),
              onTap: () async {
                await core.toggleChatFlag(
                  chat.id,
                  locked: !chat.locked,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _showCreateGroupDialog(
  BuildContext context,
  AlWazirCore core,
) async {
  final controller = TextEditingController();

  await showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: kPanel,
        title: const Text(
          'إنشاء مجموعة',
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'اسم المجموعة',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kGold,
              foregroundColor: Colors.black,
            ),
            onPressed: () async {
              final name =
                  controller.text.trim();

              if (name.isEmpty) return;

              await core.createGroup(
                name: name,
              );

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('إنشاء'),
          ),
        ],
      );
    },
  );
}

void _showGroupInfo(
  BuildContext context,
  AlWazirGroup group,
) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: kPanel,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundColor: kGold,
                foregroundColor: Colors.black,
                child: Icon(
                  Icons.groups,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                group.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                '${group.members.length} عضو',
                style: const TextStyle(
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 18),
              ListTile(
                leading: const Icon(
                  Icons.person_add,
                  color: kGold,
                ),
                title: const Text('إضافة أعضاء'),
                onTap: () {
                  Navigator.pop(context);
                  _showInfo(
                    context,
                    'أعضاء المجموعة',
                    'سيتم ربط اختيار جهات الاتصال والمزامنة في المرحلة التالية.',
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.admin_panel_settings,
                  color: kGold,
                ),
                title: const Text('المشرفون'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showStatusDialog(
  BuildContext context,
  AlWazirCore core,
) {
  final controller = TextEditingController();

  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: kPanel,
        title: const Text('إضافة حالة'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'اكتب حالتك...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kGold,
              foregroundColor: Colors.black,
            ),
            onPressed: () async {
              final text =
                  controller.text.trim();

              if (text.isEmpty) return;

              await core.createStatus(
                text: text,
              );

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('نشر'),
          ),
        ],
      );
    },
  );
}

void _showStatusView(
  BuildContext context,
  AlWazirStatus status,
) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: kPanel,
        title: Text(status.ownerName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              status.text,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              '${status.views} مشاهدة',
              style: const TextStyle(
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'الحالة تنتهي تلقائيًا بعد 24 ساعة.',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      );
    },
  );
}

void _showChannelPostDialog(
  BuildContext context,
  AlWazirCore core,
  String channelId,
) {
  final controller = TextEditingController();

  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: kPanel,
        title: const Text('منشور جديد'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'اكتب المنشور...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kGold,
              foregroundColor: Colors.black,
            ),
            onPressed: () async {
              final text =
                  controller.text.trim();

              if (text.isEmpty) return;

              await core.addChannelPost(
                channelId: channelId,
                text: text,
              );

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('نشر'),
          ),
        ],
      );
    },
  );
}

void _showProfileDialog(
  BuildContext context,
  AlWazirCore core,
) {
  final nameController = TextEditingController(
    text: core.account.name,
  );

  final phoneController = TextEditingController(
    text: core.account.phone,
  );

  final countryController = TextEditingController(
    text: core.account.countryCode,
  );

  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: kPanel,
        title: const Text('الملف الشخصي'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'الاسم',
              ),
            ),
            TextField(
              controller: countryController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'مفتاح الدولة',
              ),
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kGold,
              foregroundColor: Colors.black,
            ),
            onPressed: () async {
              final old = core.account;

              await core.saveAccount(
                old.copyWith(
                  id: old.id.isEmpty
                      ? _newId()
                      : old.id,
                  name: nameController.text.trim(),
                  countryCode:
                      countryController.text.trim(),
                  phone:
                      phoneController.text.trim(),
                  createdAt:
                      old.createdAt ?? DateTime.now(),
                ),
              );

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      );
    },
  );
}

void _showLanguageDialog(
  BuildContext context,
  AlWazirCore core,
) {
  const languages = [
    'العربية',
    'English',
  ];

  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: kPanel,
        title: const Text('اللغة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map(
            (language) {
              return ListTile(
                title: Text(language),
                trailing:
                    core.settings.language == language
                        ? const Icon(
                            Icons.check,
                            color: kGold,
                          )
                        : null,
                onTap: () async {
                  await core.updateSettings(
                    core.settings.copyWith(
                      language: language,
                    ),
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              );
            },
          ).toList(),
        ),
      );
    },
  );
}

void _showStorageInfo(
  BuildContext context,
  AlWazirCore core,
) {
  final messageCount = core.messages.values.fold<int>(
    0,
    (sum, list) => sum + list.length,
  );

  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: kPanel,
        title: const Text('التخزين'),
        content: Text(
          'الدردشات: ${core.chats.length}\n'
          'الرسائل: $messageCount\n'
          'المجموعات: ${core.groups.length}\n'
          'الحالات: ${core.statuses.length}\n'
          'القنوات: ${core.channels.length}\n'
          'المكالمات: ${core.calls.length}\n\n'
          'البيانات الأساسية محفوظة محليًا على الجهاز.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      );
    },
  );
}

void _confirmClearData(
  BuildContext context,
  AlWazirCore core,
) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: kPanel,
        title: const Text(
          'مسح البيانات؟',
        ),
        content: const Text(
          'سيتم حذف البيانات المحلية من الجهاز. هذا الإجراء لا يمكن التراجع عنه.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await core.clearLocalData();

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('حذف'),
          ),
        ],
      );
    },
  );
}

void _showInfo(
  BuildContext context,
  String title,
  String message,
) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: kPanel,
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسنًا'),
          ),
        ],
      );
    },
  );
}
