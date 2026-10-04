import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color fahadGold = Color(0xFFD4AF37);
const Color fahadBackground = Color(0xFF0D131A);
const Color fahadAppBar = Color(0xFF101820);
const Color fahadPanel = Color(0xFF18232C);

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
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

/* ============================================================
   🧠 MODELS
   ============================================================ */

class AlWazirAccount {
  final String name;
  final String phone;
  final String countryCode;
  final String about;
  final String photoPath;

  const AlWazirAccount({
    required this.name,
    required this.phone,
    required this.countryCode,
    required this.about,
    required this.photoPath,
  });

  factory AlWazirAccount.empty() {
    return const AlWazirAccount(
      name: '',
      phone: '',
      countryCode: '+967',
      about: 'الفهد أداء وتميز',
      photoPath: '',
    );
  }

  AlWazirAccount copyWith({
    String? name,
    String? phone,
    String? countryCode,
    String? about,
    String? photoPath,
  }) {
    return AlWazirAccount(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      about: about ?? this.about,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'countryCode': countryCode,
      'about': about,
      'photoPath': photoPath,
    };
  }

  factory AlWazirAccount.fromJson(Map<String, dynamic> json) {
    return AlWazirAccount(
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      countryCode: json['countryCode']?.toString() ?? '+967',
      about: json['about']?.toString() ?? 'الفهد أداء وتميز',
      photoPath: json['photoPath']?.toString() ?? '',
    );
  }
}

class AlWazirSettings {
  final bool notifications;
  final bool readReceipts;
  final bool lastSeen;
  final bool statusPrivacy;
  final bool appLock;
  final bool chatLock;
  final bool twoStepVerification;
  final String language;

  const AlWazirSettings({
    required this.notifications,
    required this.readReceipts,
    required this.lastSeen,
    required this.statusPrivacy,
    required this.appLock,
    required this.chatLock,
    required this.twoStepVerification,
    required this.language,
  });

  factory AlWazirSettings.defaults() {
    return const AlWazirSettings(
      notifications: true,
      readReceipts: true,
      lastSeen: true,
      statusPrivacy: true,
      appLock: false,
      chatLock: false,
      twoStepVerification: false,
      language: 'العربية',
    );
  }

  AlWazirSettings copyWith({
    bool? notifications,
    bool? readReceipts,
    bool? lastSeen,
    bool? statusPrivacy,
    bool? appLock,
    bool? chatLock,
    bool? twoStepVerification,
    String? language,
  }) {
    return AlWazirSettings(
      notifications: notifications ?? this.notifications,
      readReceipts: readReceipts ?? this.readReceipts,
      lastSeen: lastSeen ?? this.lastSeen,
      statusPrivacy: statusPrivacy ?? this.statusPrivacy,
      appLock: appLock ?? this.appLock,
      chatLock: chatLock ?? this.chatLock,
      twoStepVerification:
          twoStepVerification ?? this.twoStepVerification,
      language: language ?? this.language,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications,
      'readReceipts': readReceipts,
      'lastSeen': lastSeen,
      'statusPrivacy': statusPrivacy,
      'appLock': appLock,
      'chatLock': chatLock,
      'twoStepVerification': twoStepVerification,
      'language': language,
    };
  }

  factory AlWazirSettings.fromJson(Map<String, dynamic> json) {
    return AlWazirSettings(
      notifications: json['notifications'] as bool? ?? true,
      readReceipts: json['readReceipts'] as bool? ?? true,
      lastSeen: json['lastSeen'] as bool? ?? true,
      statusPrivacy: json['statusPrivacy'] as bool? ?? true,
      appLock: json['appLock'] as bool? ?? false,
      chatLock: json['chatLock'] as bool? ?? false,
      twoStepVerification:
          json['twoStepVerification'] as bool? ?? false,
      language: json['language']?.toString() ?? 'العربية',
    );
  }
}

class AlWazirChat {
  final String id;
  final String name;
  final String phone;
  final String avatar;
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
    required this.avatar,
    required this.lastMessage,
    required this.lastTime,
    required this.unread,
    required this.pinned,
    required this.muted,
    required this.locked,
  });

  AlWazirChat copyWith({
    String? name,
    String? phone,
    String? avatar,
    String? lastMessage,
    DateTime? lastTime,
    int? unread,
    bool? pinned,
    bool? muted,
    bool? locked,
  }) {
    return AlWazirChat(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      lastMessage: lastMessage ?? this.lastMessage,
      lastTime: lastTime ?? this.lastTime,
      unread: unread ?? this.unread,
      pinned: pinned ?? this.pinned,
      muted: muted ?? this.muted,
      locked: locked ?? this.locked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'avatar': avatar,
      'lastMessage': lastMessage,
      'lastTime': lastTime?.toIso8601String(),
      'unread': unread,
      'pinned': pinned,
      'muted': muted,
      'locked': locked,
    };
  }

  factory AlWazirChat.fromJson(Map<String, dynamic> json) {
    return AlWazirChat(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
      lastMessage: json['lastMessage']?.toString() ?? '',
      lastTime: json['lastTime'] == null
          ? null
          : DateTime.tryParse(json['lastTime'].toString()),
      unread: (json['unread'] as num?)?.toInt() ?? 0,
      pinned: json['pinned'] as bool? ?? false,
      muted: json['muted'] as bool? ?? false,
      locked: json['locked'] as bool? ?? false,
    );
  }
}

class AlWazirMessage {
  final String id;
  final String chatId;
  final String text;
  final DateTime time;
  final bool mine;
  final MessageStatus status;
  final String replyTo;
  final String mediaPath;
  final String mediaType;
  final bool deletedForEveryone;
  final bool deletedForMe;
  final bool pinned;
  final bool edited;

  const AlWazirMessage({
    required this.id,
    required this.chatId,
    required this.text,
    required this.time,
    required this.mine,
    required this.status,
    required this.replyTo,
    required this.mediaPath,
    required this.mediaType,
    required this.deletedForEveryone,
    required this.deletedForMe,
    required this.pinned,
    required this.edited,
  });

  AlWazirMessage copyWith({
    String? text,
    MessageStatus? status,
    String? replyTo,
    String? mediaPath,
    String? mediaType,
    bool? deletedForEveryone,
    bool? deletedForMe,
    bool? pinned,
    bool? edited,
  }) {
    return AlWazirMessage(
      id: id,
      chatId: chatId,
      text: text ?? this.text,
      time: time,
      mine: mine,
      status: status ?? this.status,
      replyTo: replyTo ?? this.replyTo,
      mediaPath: mediaPath ?? this.mediaPath,
      mediaType: mediaType ?? this.mediaType,
      deletedForEveryone:
          deletedForEveryone ?? this.deletedForEveryone,
      deletedForMe: deletedForMe ?? this.deletedForMe,
      pinned: pinned ?? this.pinned,
      edited: edited ?? this.edited,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'text': text,
      'time': time.toIso8601String(),
      'mine': mine,
      'status': status.name,
      'replyTo': replyTo,
      'mediaPath': mediaPath,
      'mediaType': mediaType,
      'deletedForEveryone': deletedForEveryone,
      'deletedForMe': deletedForMe,
      'pinned': pinned,
      'edited': edited,
    };
  }

  factory AlWazirMessage.fromJson(Map<String, dynamic> json) {
    final statusName = json['status']?.toString() ?? 'sent';

    return AlWazirMessage(
      id: json['id']?.toString() ?? '',
      chatId: json['chatId']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      time: DateTime.tryParse(json['time']?.toString() ?? '') ??
          DateTime.now(),
      mine: json['mine'] as bool? ?? false,
      status: MessageStatus.values.firstWhere(
        (e) => e.name == statusName,
        orElse: () => MessageStatus.sent,
      ),
      replyTo: json['replyTo']?.toString() ?? '',
      mediaPath: json['mediaPath']?.toString() ?? '',
      mediaType: json['mediaType']?.toString() ?? '',
      deletedForEveryone:
          json['deletedForEveryone'] as bool? ?? false,
      deletedForMe: json['deletedForMe'] as bool? ?? false,
      pinned: json['pinned'] as bool? ?? false,
      edited: json['edited'] as bool? ?? false,
    );
  }
}

class AlWazirGroup {
  final String id;
  final String name;
  final String photo;
  final List<String> members;
  final List<String> admins;
  final DateTime createdAt;

  const AlWazirGroup({
    required this.id,
    required this.name,
    required this.photo,
    required this.members,
    required this.admins,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'members': members,
      'admins': admins,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AlWazirGroup.fromJson(Map<String, dynamic> json) {
    return AlWazirGroup(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      photo: json['photo']?.toString() ?? '',
      members: List<String>.from(json['members'] ?? const []),
      admins: List<String>.from(json['admins'] ?? const []),
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
              DateTime.now(),
    );
  }
}

class AlWazirStatus {
  final String id;
  final String text;
  final String mediaPath;
  final String mediaType;
  final DateTime createdAt;
  final DateTime expiresAt;
  final int views;

  const AlWazirStatus({
    required this.id,
    required this.text,
    required this.mediaPath,
    required this.mediaType,
    required this.createdAt,
    required this.expiresAt,
    required this.views,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'mediaPath': mediaPath,
      'mediaType': mediaType,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'views': views,
    };
  }

  factory AlWazirStatus.fromJson(Map<String, dynamic> json) {
    return AlWazirStatus(
      id: json['id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      mediaPath: json['mediaPath']?.toString() ?? '',
      mediaType: json['mediaType']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
              DateTime.now(),
      expiresAt:
          DateTime.tryParse(json['expiresAt']?.toString() ?? '') ??
              DateTime.now().add(const Duration(hours: 24)),
      views: (json['views'] as num?)?.toInt() ?? 0,
    );
  }
}

class AlWazirChannelPost {
  final String id;
  final String text;
  final DateTime createdAt;
  final bool advertisement;

  const AlWazirChannelPost({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.advertisement,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'advertisement': advertisement,
    };
  }

  factory AlWazirChannelPost.fromJson(Map<String, dynamic> json) {
    return AlWazirChannelPost(
      id: json['id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
              DateTime.now(),
      advertisement: json['advertisement'] as bool? ?? false,
    );
  }
}

class AlWazirChannel {
  final String id;
  final String name;
  final String description;
  final bool verified;
  final bool following;
  final List<AlWazirChannelPost> posts;

  const AlWazirChannel({
    required this.id,
    required this.name,
    required this.description,
    required this.verified,
    required this.following,
    required this.posts,
  });

  AlWazirChannel copyWith({
    bool? following,
    List<AlWazirChannelPost>? posts,
  }) {
    return AlWazirChannel(
      id: id,
      name: name,
      description: description,
      verified: verified,
      following: following ?? this.following,
      posts: posts ?? this.posts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'verified': verified,
      'following': following,
      'posts': posts.map((e) => e.toJson()).toList(),
    };
  }

  factory AlWazirChannel.fromJson(Map<String, dynamic> json) {
    return AlWazirChannel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      verified: json['verified'] as bool? ?? false,
      following: json['following'] as bool? ?? false,
      posts: (json['posts'] as List? ?? [])
          .whereType<Map>()
          .map(
            (e) => AlWazirChannelPost.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
    );
  }
}

class AlWazirCall {
  final String id;
  final String name;
  final CallType type;
  final CallDirection direction;
  final DateTime time;

  const AlWazirCall({
    required this.id,
    required this.name,
    required this.type,
    required this.direction,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'direction': direction.name,
      'time': time.toIso8601String(),
    };
  }

  factory AlWazirCall.fromJson(Map<String, dynamic> json) {
    return AlWazirCall(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: CallType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => CallType.voice,
      ),
      direction: CallDirection.values.firstWhere(
        (e) => e.name == json['direction'],
        orElse: () => CallDirection.outgoing,
      ),
      time: DateTime.tryParse(json['time']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

/* ============================================================
   🧠 AL-WAZIR CORE
   ============================================================ */

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

  Future<void> ensureReady() async {
    if (!initialized) {
      await init();
    }
  }

  Future<void> init() async {
    if (initialized) return;

    _prefs = await SharedPreferences.getInstance();

    _loadAccount();
    _loadSettings();
    _loadChats();
    _loadMessages();
    _loadGroups();
    _loadStatuses();
    _loadChannels();
    _loadCalls();

    _removeExpiredStatuses();

    if (channels.isEmpty) {
      channels.add(
        AlWazirChannel(
          id: 'official-fahad',
          name: 'قناة الفهد الرسمية',
          description: 'آخر الأخبار والتحديثات',
          verified: true,
          following: true,
          posts: const [],
        ),
      );
      await _saveChannels();
    }

    initialized = true;
    notifyListeners();
  }

  void _loadAccount() {
    final raw = _prefs?.getString(_accountKey);
    if (raw == null || raw.isEmpty) return;

    try {
      account = AlWazirAccount.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw)),
      );
    } catch (_) {}
  }

  void _loadSettings() {
    final raw = _prefs?.getString(_settingsKey);
    if (raw == null || raw.isEmpty) return;

    try {
      settings = AlWazirSettings.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw)),
      );
    } catch (_) {}
  }

  void _loadChats() {
    final raw = _prefs?.getString(_chatsKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final list = jsonDecode(raw) as List;
      chats
        ..clear()
        ..addAll(
          list
              .whereType<Map>()
              .map(
                (e) => AlWazirChat.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              ),
        );
    } catch (_) {}
  }

  void _loadMessages() {
    final raw = _prefs?.getString(_messagesKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final map = Map<String, dynamic>.from(jsonDecode(raw));

      messages.clear();

      for (final entry in map.entries) {
        final list = entry.value as List? ?? [];

        messages[entry.key] = list
            .whereType<Map>()
            .map(
              (e) => AlWazirMessage.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList();
      }
    } catch (_) {}
  }

  void _loadGroups() {
    final raw = _prefs?.getString(_groupsKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final list = jsonDecode(raw) as List;
      groups
        ..clear()
        ..addAll(
          list
              .whereType<Map>()
              .map(
                (e) => AlWazirGroup.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              ),
        );
    } catch (_) {}
  }

  void _loadStatuses() {
    final raw = _prefs?.getString(_statusesKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final list = jsonDecode(raw) as List;
      statuses
        ..clear()
        ..addAll(
          list
              .whereType<Map>()
              .map(
                (e) => AlWazirStatus.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              ),
        );
    } catch (_) {}
  }

  void _loadChannels() {
    final raw = _prefs?.getString(_channelsKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final list = jsonDecode(raw) as List;
      channels
        ..clear()
        ..addAll(
          list
              .whereType<Map>()
              .map(
                (e) => AlWazirChannel.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              ),
        );
    } catch (_) {}
  }

  void _loadCalls() {
    final raw = _prefs?.getString(_callsKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final list = jsonDecode(raw) as List;
      calls
        ..clear()
        ..addAll(
          list
              .whereType<Map>()
              .map(
                (e) => AlWazirCall.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              ),
        );
    } catch (_) {}
  }

  void _removeExpiredStatuses() {
    final now = DateTime.now();

    statuses.removeWhere(
      (status) => status.expiresAt.isBefore(now),
    );
  }

  Future<void> saveAccount(AlWazirAccount value) async {
    await ensureReady();

    account = value;

    await _prefs!.setString(
      _accountKey,
      jsonEncode(account.toJson()),
    );

    notifyListeners();
  }

  Future<void> updateSettings(
    AlWazirSettings value,
  ) async {
    await ensureReady();

    settings = value;

    await _prefs!.setString(
      _settingsKey,
      jsonEncode(settings.toJson()),
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
    return List.unmodifiable(messages[chatId] ?? const []);
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
      avatar: '',
      lastMessage: '',
      lastTime: null,
      unread: 0,
      pinned: false,
      muted: false,
      locked: false,
    );

    chats.add(created);

    await _saveChats();

    notifyListeners();

    return created;
  }

  Future<AlWazirMessage> sendMessage({
    required String chatId,
    required String text,
    String replyTo = '',
  }) async {
    await ensureReady();

    final value = text.trim();

    if (value.isEmpty) {
      throw ArgumentError('الرسالة فارغة');
    }

    final now = DateTime.now();

    final message = AlWazirMessage(
      id: '${now.microsecondsSinceEpoch}',
      chatId: chatId,
      text: value,
      time: now,
      mine: true,
      status: settings.readReceipts
          ? MessageStatus.read
          : MessageStatus.sent,
      replyTo: replyTo,
      mediaPath: '',
      mediaType: '',
      deletedForEveryone: false,
      deletedForMe: false,
      pinned: false,
      edited: false,
    );

    messages.putIfAbsent(chatId, () => []);
    messages[chatId]!.add(message);

    final current = chat(chatId);

    if (current != null) {
      final index = chats.indexWhere((e) => e.id == chatId);

      chats[index] = current.copyWith(
        lastMessage: value,
        lastTime: now,
        unread: 0,
      );
    }

    await _saveMessages();
    await _saveChats();

    notifyListeners();

    return message;
  }

  Future<void> editMessage(
    String chatId,
    String messageId,
    String newText,
  ) async {
    await ensureReady();

    final list = messages[chatId];

    if (list == null) return;

    final index = list.indexWhere(
      (e) => e.id == messageId,
    );

    if (index < 0) return;

    list[index] = list[index].copyWith(
      text: newText.trim(),
      edited: true,
    );

    await _saveMessages();

    final current = chat(chatId);

    if (current != null &&
        current.lastMessage == list[index].text) {
      final chatIndex = chats.indexWhere(
        (e) => e.id == chatId,
      );

      chats[chatIndex] = current.copyWith(
        lastMessage: newText.trim(),
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

    final list = messages[chatId];

    if (list == null) return;

    final index = list.indexWhere(
      (e) => e.id == messageId,
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

    final list = messages[chatId];

    if (list == null) return;

    final index = list.indexWhere(
      (e) => e.id == messageId,
    );

    if (index < 0) return;

    list[index] = list[index].copyWith(
      deletedForEveryone: true,
      text: 'تم حذف هذه الرسالة',
    );

    await _saveMessages();

    notifyListeners();
  }

  Future<void> togglePinnedMessage(
    String chatId,
    String messageId,
  ) async {
    await ensureReady();

    final list = messages[chatId];

    if (list == null) return;

    final index = list.indexWhere(
      (e) => e.id == messageId,
    );

    if (index < 0) return;

    final item = list[index];

    list[index] = item.copyWith(
      pinned: !item.pinned,
    );

    await _saveMessages();

    notifyListeners();
  }

  Future<void> markRead(String chatId) async {
    await ensureReady();

    final current = chat(chatId);

    if (current != null) {
      final index = chats.indexWhere(
        (e) => e.id == chatId,
      );

      chats[index] = current.copyWith(
        unread: 0,
      );

      await _saveChats();
    }

    notifyListeners();
  }

  Future<void> toggleChatPinned(String chatId) async {
    await ensureReady();

    final item = chat(chatId);

    if (item == null) return;

    final index = chats.indexWhere(
      (e) => e.id == chatId,
    );

    chats[index] = item.copyWith(
      pinned: !item.pinned,
    );

    await _saveChats();

    notifyListeners();
  }

  Future<void> toggleChatMuted(String chatId) async {
    await ensureReady();

    final item = chat(chatId);

    if (item == null) return;

    final index = chats.indexWhere(
      (e) => e.id == chatId,
    );

    chats[index] = item.copyWith(
      muted: !item.muted,
    );

    await _saveChats();

    notifyListeners();
  }

  Future<void> toggleChatLocked(String chatId) async {
    await ensureReady();

    final item = chat(chatId);

    if (item == null) return;

    final index = chats.indexWhere(
      (e) => e.id == chatId,
    );

    chats[index] = item.copyWith(
      locked: !item.locked,
    );

    await _saveChats();

    notifyListeners();
  }

  Future<void> createGroup({
    required String name,
  }) async {
    await ensureReady();

    final value = name.trim();

    if (value.isEmpty) return;

    final now = DateTime.now();

    final group = AlWazirGroup(
      id: '${now.microsecondsSinceEpoch}',
      name: value,
      photo: '',
      members: const [],
      admins: const [],
      createdAt: now,
    );

    groups.add(group);

    await _saveGroups();

    notifyListeners();
  }

  Future<void> createStatus({
    String text = '',
    String mediaPath = '',
    String mediaType = '',
  }) async {
    await ensureReady();

    if (text.trim().isEmpty && mediaPath.isEmpty) {
      return;
    }

    final now = DateTime.now();

    statuses.add(
      AlWazirStatus(
        id: '${now.microsecondsSinceEpoch}',
        text: text.trim(),
        mediaPath: mediaPath,
        mediaType: mediaType,
        createdAt: now,
        expiresAt: now.add(
          const Duration(hours: 24),
        ),
        views: 0,
      ),
    );

    await _saveStatuses();

    notifyListeners();
  }

  Future<void> deleteStatus(String id) async {
    await ensureReady();

    statuses.removeWhere(
      (status) => status.id == id,
    );

    await _saveStatuses();

    notifyListeners();
  }

  Future<void> toggleFollowChannel(String id) async {
    await ensureReady();

    final index = channels.indexWhere(
      (e) => e.id == id,
    );

    if (index < 0) return;

    channels[index] = channels[index].copyWith(
      following: !channels[index].following,
    );

    await _saveChannels();

    notifyListeners();
  }

  Future<void> addChannelPost({
    required String channelId,
    required String text,
    bool advertisement = false,
  }) async {
    await ensureReady();

    final index = channels.indexWhere(
      (e) => e.id == channelId,
    );

    if (index < 0 || text.trim().isEmpty) return;

    final post = AlWazirChannelPost(
      id: '${DateTime.now().microsecondsSinceEpoch}',
      text: text.trim(),
      createdAt: DateTime.now(),
      advertisement: advertisement,
    );

    final channel = channels[index];

    channels[index] = channel.copyWith(
      posts: [
        ...channel.posts,
        post,
      ],
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
        id: '${DateTime.now().microsecondsSinceEpoch}',
        name: name,
        type: type,
        direction: direction,
        time: DateTime.now(),
      ),
    );

    await _saveCalls();

    notifyListeners();
  }

  Future<void> _saveAccount() async {
    await _prefs!.setString(
      _accountKey,
      jsonEncode(account.toJson()),
    );
  }

  Future<void> _saveSettings() async {
    await _prefs!.setString(
      _settingsKey,
      jsonEncode(settings.toJson()),
    );
  }

  Future<void> _saveChats() async {
    await _prefs!.setString(
      _chatsKey,
      jsonEncode(
        chats.map((e) => e.toJson()).toList(),
      ),
    );
  }

  Future<void> _saveMessages() async {
    final output = <String, dynamic>{};

    messages.forEach(
      (key, value) {
        output[key] = value
            .map((e) => e.toJson())
            .toList();
      },
    );

    await _prefs!.setString(
      _messagesKey,
      jsonEncode(output),
    );
  }

  Future<void> _saveGroups() async {
    await _prefs!.setString(
      _groupsKey,
      jsonEncode(
        groups.map((e) => e.toJson()).toList(),
      ),
    );
  }

  Future<void> _saveStatuses() async {
    await _prefs!.setString(
      _statusesKey,
      jsonEncode(
        statuses.map((e) => e.toJson()).toList(),
      ),
    );
  }

  Future<void> _saveChannels() async {
    await _prefs!.setString(
      _channelsKey,
      jsonEncode(
        channels.map((e) => e.toJson()).toList(),
      ),
    );
  }

  Future<void> _saveCalls() async {
    await _prefs!.setString(
      _callsKey,
      jsonEncode(
        calls.map((e) => e.toJson()).toList(),
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

    await _prefs!.remove(_accountKey);
    await _prefs!.remove(_settingsKey);
    await _prefs!.remove(_chatsKey);
    await _prefs!.remove(_messagesKey);
    await _prefs!.remove(_groupsKey);
    await _prefs!.remove(_statusesKey);
    await _prefs!.remove(_channelsKey);
    await _prefs!.remove(_callsKey);

    notifyListeners();
  }
}

/* ============================================================
   🏠 MAIN HOME
   ============================================================ */

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
  late final AlWazirCore core;

  int currentIndex = 0;

  static const List<String> titles = [
    'الدردشات',
    'المجموعات',
    'المكالمات',
    'الحالة',
    'القنوات',
  ];

  @override
  void initState() {
    super.initState();

    core = widget.core is AlWazirCore
        ? widget.core as AlWazirCore
        : AlWazirCore.instance;

    core.init();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedBuilder(
        animation: core,
        builder: (context, _) {
          return Scaffold(
            backgroundColor: fahadBackground,
            appBar: AppBar(
              backgroundColor: fahadAppBar,
              elevation: 0,
              centerTitle: true,
              title: Text(
                currentIndex == 0
                    ? 'الفهد'
                    : titles[currentIndex],
                style: const TextStyle(
                  color: fahadGold,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  tooltip: 'الكاميرا',
                  onPressed: () {
                    if (currentIndex == 3) {
                      _openCreateStatus();
                    } else {
                      _showMessage('الكاميرا سيتم ربطها في مرحلة الوسائط');
                    }
                  },
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: fahadGold,
                  ),
                ),
                IconButton(
                  tooltip: 'البحث',
                  onPressed: _openSearch,
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  tooltip: 'الإعدادات',
                  onPressed: _openSettings,
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
                ChatsPage(core: core),
                GroupsPage(core: core),
                CallsPage(core: core),
                StatusPage(core: core),
                ChannelsPage(core: core),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              backgroundColor: fahadPanel,
              selectedIndex: currentIndex,
              indicatorColor: const Color(0x33D4AF37),
              labelTextStyle:
                  WidgetStateProperty.all(
                const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onDestinationSelected: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(
                    Icons.chat_bubble_outline,
                  ),
                  selectedIcon: Icon(
                    Icons.chat_bubble,
                    color: fahadGold,
                  ),
                  label: 'الدردشات',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.groups_outlined,
                  ),
                  selectedIcon: Icon(
                    Icons.groups,
                    color: fahadGold,
                  ),
                  label: 'المجموعات',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.call_outlined,
                  ),
                  selectedIcon: Icon(
                    Icons.call,
                    color: fahadGold,
                  ),
                  label: 'المكالمات',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.circle_outlined,
                  ),
                  selectedIcon: Icon(
                    Icons.circle,
                    color: fahadGold,
                  ),
                  label: 'الحالة',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.campaign_outlined,
                  ),
                  selectedIcon: Icon(
                    Icons.campaign,
                    color: fahadGold,
                  ),
                  label: 'القنوات',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openCreateStatus() {
    showDialog<void>(
      context: context,
      builder: (_) {
        final controller = TextEditingController();

        return AlertDialog(
          backgroundColor: fahadPanel,
          title: const Text(
            'إضافة حالة',
            textAlign: TextAlign.right,
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'اكتب حالتك...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: fahadGold,
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                await core.createStatus(
                  text: controller.text,
                );

                if (mounted) {
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

  void _openSearch() {
    showSearch<void>(
      context: context,
      delegate: FahadSearchDelegate(core),
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsPage(core: core),
      ),
    );
  }
}

/* ============================================================
   💬 CHATS
   ============================================================ */

class ChatsPage extends StatelessWidget {
  final AlWazirCore core;

  const ChatsPage({
    super.key,
    required this.core,
  });

  @override
  Widget build(BuildContext context) {
    final list = [...core.chats];

    list.sort(
      (a, b) {
        if (a.pinned != b.pinned) {
          return a.pinned ? -1 : 1;
        }

        final at =
            a.lastTime ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bt =
            b.lastTime ?? DateTime.fromMillisecondsSinceEpoch(0);

        return bt.compareTo(at);
      },
    );

    if (list.isEmpty) {
      return _EmptyState(
        icon: Icons.chat_bubble_outline,
        title: 'لا توجد محادثات بعد',
        subtitle: 'ابدأ محادثة جديدة ليتم حفظها هنا',
        actionText: 'بدء محادثة',
        onAction: () async {
          await _createChat(context);
        },
      );
    }

    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(
            12,
            12,
            12,
            90,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final chat = list[index];

            return _ChatTile(
              chat: chat,
              onTap: () async {
                await core.markRead(chat.id);

                if (!context.mounted) return;

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
                _chatMenu(context, chat);
              },
            );
          },
        ),
        Positioned(
          left: 20,
          bottom: 20,
          child: FloatingActionButton(
            backgroundColor: fahadGold,
            foregroundColor: Colors.black,
            onPressed: () => _createChat(context),
            child: const Icon(Icons.chat),
          ),
        ),
      ],
    );
  }

  Future<void> _createChat(BuildContext context) async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: fahadPanel,
          title: const Text('محادثة جديدة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم الشخص',
                ),
              ),
              const SizedBox(height: 10),
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
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: fahadGold,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  return;
                }

                Navigator.pop(context, true);
              },
              child: const Text('إنشاء'),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    final id =
        'chat_${DateTime.now().microsecondsSinceEpoch}';

    await core.ensureChat(
      id: id,
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
    );

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatRoomScreen(
          core: core,
          chatId: id,
        ),
      ),
    );
  }

  void _chatMenu(
    BuildContext context,
    AlWazirChat chat,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: fahadPanel,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.push_pin_outlined,
                  color: fahadGold,
                ),
                title: Text(
                  chat.pinned
                      ? 'إلغاء التثبيت'
                      : 'تثبيت المحادثة',
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await core.toggleChatPinned(chat.id);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.notifications_off_outlined,
                  color: fahadGold,
                ),
                title: Text(
                  chat.muted
                      ? 'إلغاء الكتم'
                      : 'كتم المحادثة',
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await core.toggleChatMuted(chat.id);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.lock_outline,
                  color: fahadGold,
                ),
                title: Text(
                  chat.locked
                      ? 'إلغاء قفل المحادثة'
                      : 'قفل المحادثة',
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await core.toggleChatLocked(chat.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

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
      color: fahadPanel,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 3,
        ),
        leading: CircleAvatar(
          radius: 27,
          backgroundColor: fahadGold,
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (chat.pinned)
              const Icon(
                Icons.push_pin,
                size: 15,
                color: fahadGold,
              ),
            if (chat.muted)
              const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.notifications_off,
                  size: 15,
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
              _formatTime(chat.lastTime),
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
            if (chat.unread > 0) ...[
              const SizedBox(height: 5),
              CircleAvatar(
                radius: 10,
                backgroundColor: fahadGold,
                child: Text(
                  '${chat.unread}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 11,
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

/* ============================================================
   💬 CHAT ROOM
   ============================================================ */

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
  final TextEditingController controller =
      TextEditingController();

  final FocusNode focusNode = FocusNode();

  String replyTo = '';

  @override
  void initState() {
    super.initState();

    widget.core.markRead(widget.chatId);
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chat = widget.core.chat(widget.chatId);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: fahadBackground,
        appBar: AppBar(
          backgroundColor: fahadAppBar,
          titleSpacing: 0,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: fahadGold,
                foregroundColor: Colors.black,
                child: Text(
                  chat?.name.isNotEmpty == true
                      ? chat!.name.characters.first
                      : '?',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat?.name ?? 'محادثة',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'متصل',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                _startCall(CallType.video);
              },
              icon: const Icon(
                Icons.videocam_outlined,
              ),
            ),
            IconButton(
              onPressed: () {
                _startCall(CallType.voice);
              },
              icon: const Icon(
                Icons.call_outlined,
              ),
            ),
          ],
        ),
        body: AnimatedBuilder(
          animation: widget.core,
          builder: (context, _) {
            final items =
                widget.core.chatMessages(widget.chatId);

            return Column(
              children: [
                Expanded(
                  child: items.isEmpty
                      ? const _EmptyState(
                          icon: Icons.chat_bubble_outline,
                          title: 'لا توجد رسائل',
                          subtitle:
                              'ابدأ المحادثة الآن',
                        )
                      : ListView.builder(
                          reverse: false,
                          padding: const EdgeInsets.all(12),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final message = items[index];

                            if (message.deletedForMe) {
                              return const SizedBox.shrink();
                            }

                            return _MessageBubble(
                              message: message,
                              onLongPress: () {
                                _messageMenu(message);
                              },
                            );
                          },
                        ),
                ),
                if (replyTo.isNotEmpty)
                  Container(
                    width: double.infinity,
                    color: fahadPanel,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.reply,
                          color: fahadGold,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'الرد على: $replyTo',
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              replyTo = '';
                            });
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                _Composer(
                  controller: controller,
                  focusNode: focusNode,
                  onSend: _send,
                  onAttach: _attachments,
                  onVoice: _voice,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _send() async {
    final text = controller.text.trim();

    if (text.isEmpty) return;

    await widget.core.sendMessage(
      chatId: widget.chatId,
      text: text,
      replyTo: replyTo,
    );

    controller.clear();

    setState(() {
      replyTo = '';
    });

    focusNode.requestFocus();
  }

  void _attachments() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: fahadPanel,
      builder: (_) {
        return SafeArea(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            padding: const EdgeInsets.all(16),
            children: [
              _AttachItem(
                icon: Icons.photo,
                label: 'المعرض',
                onTap: () {
                  Navigator.pop(context);
                  _notReady('المعرض');
                },
              ),
              _AttachItem(
                icon: Icons.camera_alt,
                label: 'الكاميرا',
                onTap: () {
                  Navigator.pop(context);
                  _notReady('الكاميرا');
                },
              ),
              _AttachItem(
                icon: Icons.videocam,
                label: 'فيديو',
                onTap: () {
                  Navigator.pop(context);
                  _notReady('الفيديو');
                },
              ),
              _AttachItem(
                icon: Icons.insert_drive_file,
                label: 'ملف',
                onTap: () {
                  Navigator.pop(context);
                  _notReady('الملفات');
                },
              ),
              _AttachItem(
                icon: Icons.location_on,
                label: 'الموقع',
                onTap: () {
                  Navigator.pop(context);
                  _notReady('الموقع');
                },
              ),
              _AttachItem(
                icon: Icons.contact_page,
                label: 'جهة اتصال',
                onTap: () {
                  Navigator.pop(context);
                  _notReady('جهات الاتصال');
                },
              ),
              _AttachItem(
                icon: Icons.gif_box,
                label: 'GIF',
                onTap: () {
                  Navigator.pop(context);
                  _notReady('GIF');
                },
              ),
              _AttachItem(
                icon: Icons.emoji_emotions,
                label: 'ملصق',
                onTap: () {
                  Navigator.pop(context);
                  _notReady('الملصقات');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _voice() {
    _notReady(
      'التسجيل الصوتي الحقيقي سيكون في مرحلة ربط record',
    );
  }

  void _notReady(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$name جاهز للربط في مرحلة الوسائط الحقيقية',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _messageMenu(AlWazirMessage message) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: fahadPanel,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.reply,
                  color: fahadGold,
                ),
                title: const Text('رد'),
                onTap: () {
                  Navigator.pop(context);

                  setState(() {
                    replyTo = message.text;
                  });

                  focusNode.requestFocus();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.push_pin_outlined,
                  color: fahadGold,
                ),
                title: Text(
                  message.pinned
                      ? 'إلغاء التثبيت'
                      : 'تثبيت',
                ),
                onTap: () async {
                  Navigator.pop(context);

                  await widget.core
                      .togglePinnedMessage(
                    widget.chatId,
                    message.id,
                  );
                },
              ),
              if (message.mine)
                ListTile(
                  leading: const Icon(
                    Icons.edit,
                    color: fahadGold,
                  ),
                  title: const Text('تعديل'),
                  onTap: () {
                    Navigator.pop(context);
                    _editMessage(message);
                  },
                ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
                title: const Text('حذف لدي'),
                onTap: () async {
                  Navigator.pop(context);

                  await widget.core.deleteForMe(
                    widget.chatId,
                    message.id,
                  );
                },
              ),
              if (message.mine)
                ListTile(
                  leading: const Icon(
                    Icons.delete_forever,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    'حذف للجميع',
                  ),
                  onTap: () async {
                    Navigator.pop(context);

                    await widget.core
                        .deleteForEveryone(
                      widget.chatId,
                      message.id,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _editMessage(AlWazirMessage message) {
    final editController = TextEditingController(
      text: message.text,
    );

    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: fahadPanel,
          title: const Text('تعديل الرسالة'),
          content: TextField(
            controller: editController,
            autofocus: true,
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: fahadGold,
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                await widget.core.editMessage(
                  widget.chatId,
                  message.id,
                  editController.text,
                );

                if (mounted) {
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

  Future<void> _startCall(CallType type) async {
    final chat = widget.core.chat(widget.chatId);

    if (chat == null) return;

    await widget.core.addCall(
      name: chat.name,
      type: type,
      direction: CallDirection.outgoing,
    );

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CallScreen(
          core: widget.core,
          name: chat.name,
          type: type,
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final AlWazirMessage message;
  final VoidCallback onLongPress;

  const _MessageBubble({
    required this.message,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final mine = message.mine;

    return Align(
      alignment:
          mine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 330,
          ),
          margin: const EdgeInsets.only(bottom: 7),
          padding: const EdgeInsets.fromLTRB(
            12,
            9,
            10,
            7,
          ),
          decoration: BoxDecoration(
            color: mine
                ? const Color(0xFF304A3B)
                : fahadPanel,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              if (message.replyTo.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(7),
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  child: Text(
                    message.replyTo,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      message.deletedForEveryone
                          ? 'تم حذف هذه الرسالة'
                          : message.text,
                      style: TextStyle(
                        color: message.deletedForEveryone
                            ? Colors.white54
                            : Colors.white,
                        fontStyle:
                            message.deletedForEveryone
                                ? FontStyle.italic
                                : FontStyle.normal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(message.time),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                  if (mine) ...[
                    const SizedBox(width: 3),
                    _StatusIcon(
                      status: message.status,
                    ),
                  ],
                ],
              ),
              if (message.edited)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'معدلة',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 9,
                    ),
                  ),
                ),
              if (message.pinned)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.push_pin,
                    size: 13,
                    color: fahadGold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final MessageStatus status;

  const _StatusIcon({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MessageStatus.sending:
        return const Icon(
          Icons.access_time,
          size: 14,
          color: Colors.white54,
        );
      case MessageStatus.sent:
        return const Icon(
          Icons.check,
          size: 14,
          color: Colors.white54,
        );
      case MessageStatus.delivered:
        return const Icon(
          Icons.done_all,
          size: 14,
          color: Colors.white54,
        );
      case MessageStatus.read:
        return const Icon(
          Icons.done_all,
          size: 14,
          color: fahadGold,
        );
      case MessageStatus.failed:
        return const Icon(
          Icons.error_outline,
          size: 14,
          color: Colors.redAccent,
        );
    }
  }
}

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final VoidCallback onAttach;
  final VoidCallback onVoice;

  const _Composer({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onAttach,
    required this.onVoice,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: fahadAppBar,
        padding: const EdgeInsets.fromLTRB(
          7,
          7,
          7,
          7,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: onAttach,
              icon: const Icon(
                Icons.add_circle_outline,
                color: fahadGold,
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                textInputAction:
                    TextInputAction.newline,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'اكتب رسالة...',
                  filled: true,
                  fillColor: fahadPanel,
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.emoji_emotions_outlined,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.gif_box_outlined,
                      color: fahadGold,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                final hasText =
                    value.text.trim().isNotEmpty;

                return CircleAvatar(
                  backgroundColor: fahadGold,
                  foregroundColor: Colors.black,
                  child: IconButton(
                    onPressed:
                        hasText ? onSend : onVoice,
                    icon: Icon(
                      hasText
                          ? Icons.send
                          : Icons.mic,
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
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: fahadGold,
            foregroundColor: Colors.black,
            child: Icon(icon),
          ),
          const SizedBox(height: 6),
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

/* ============================================================
   👥 GROUPS
   ============================================================ */

class GroupsPage extends StatelessWidget {
  final AlWazirCore core;

  const GroupsPage({
    super.key,
    required this.core,
  });

  @override
  Widget build(BuildContext context) {
    if (core.groups.isEmpty) {
      return _EmptyState(
        icon: Icons.groups_outlined,
        title: 'لا توجد مجموعات',
        subtitle: 'أنشئ مجموعة جديدة وابدأ',
        actionText: 'إنشاء مجموعة',
        onAction: () => _createGroup(context),
      );
    }

    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(
            12,
            12,
            12,
            90,
          ),
          itemCount: core.groups.length,
          itemBuilder: (_, index) {
            final group = core.groups[index];

            return Card(
              color: fahadPanel,
              margin:
                  const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: fahadGold,
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
                  color: fahadGold,
                ),
              ),
            );
          },
        ),
        Positioned(
          left: 20,
          bottom: 20,
          child: FloatingActionButton(
            backgroundColor: fahadGold,
            foregroundColor: Colors.black,
            onPressed: () => _createGroup(context),
            child: const Icon(Icons.group_add),
          ),
        ),
      ],
    );
  }

  void _createGroup(BuildContext context) {
    final controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: fahadPanel,
          title: const Text('إنشاء مجموعة'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'اسم المجموعة',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: fahadGold,
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                await core.createGroup(
                  name: controller.text,
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
}

/* ============================================================
   📞 CALLS
   ============================================================ */

class CallsPage extends StatelessWidget {
  final AlWazirCore core;

  const CallsPage({
    super.key,
    required this.core,
  });

  @override
  Widget build(BuildContext context) {
    if (core.calls.isEmpty) {
      return const _EmptyState(
        icon: Icons.call_outlined,
        title: 'لا يوجد سجل مكالمات',
        subtitle: 'ستظهر المكالمات هنا بعد استخدامها',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: core.calls.length,
      itemBuilder: (_, index) {
        final call = core.calls[index];

        final missed =
            call.direction == CallDirection.missed;

        return Card(
          color: fahadPanel,
          margin:
              const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: fahadGold,
              foregroundColor: Colors.black,
              child: Icon(
                call.type == CallType.video
                    ? Icons.videocam
                    : missed
                        ? Icons.call_missed
                        : Icons.call,
              ),
            ),
            title: Text(
              call.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(
                  call.direction ==
                          CallDirection.incoming
                      ? Icons.call_received
                      : call.direction ==
                              CallDirection.missed
                          ? Icons.call_missed
                          : Icons.call_made,
                  size: 15,
                  color: missed
                      ? Colors.redAccent
                      : fahadGold,
                ),
                const SizedBox(width: 5),
                Text(
                  call.type == CallType.video
                      ? 'مكالمة فيديو'
                      : 'مكالمة صوتية',
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () async {
                await core.addCall(
                  name: call.name,
                  type: call.type,
                  direction:
                      CallDirection.outgoing,
                );

                if (!context.mounted) return;

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
              icon: Icon(
                call.type == CallType.video
                    ? Icons.videocam
                    : Icons.call,
                color: fahadGold,
              ),
            ),
          ),
        );
      },
    );
  }
}

/* ============================================================
   📸 STATUS
   ============================================================ */

class StatusPage extends StatelessWidget {
  final AlWazirCore core;

  const StatusPage({
    super.key,
    required this.core,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = core.statuses;

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(
            12,
            12,
            12,
            90,
          ),
          children: [
            Card(
              color: fahadPanel,
              child: ListTile(
                leading: Container(
                  width: 55,
                  height: 55,
                  decoration:
                      const BoxDecoration(
                    color: fahadGold,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
                title: const Text(
                  'حالتي',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'إضافة حالة جديدة',
                ),
                onTap: () =>
                    _addStatus(context),
              ),
            ),
            const SizedBox(height: 10),
            if (statuses.isNotEmpty)
              const Text(
                'حالاتي',
                style: TextStyle(
                  color: fahadGold,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            const SizedBox(height: 8),
            ...statuses.map(
              (status) {
                return Card(
                  color: fahadPanel,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: fahadGold,
                      foregroundColor: Colors.black,
                      child: Icon(
                        Icons.circle,
                      ),
                    ),
                    title: Text(
                      status.text.isEmpty
                          ? 'حالة وسائط'
                          : status.text,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      'المشاهدات: ${status.views}',
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        await core.deleteStatus(
                          status.id,
                        );
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                );
              },
            ),
            const Divider(height: 30),
            const Text(
              'الحالات الأخيرة',
              style: TextStyle(
                color: fahadGold,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 10),
            const _StatusTile(
              name: 'محمد',
              time: 'منذ 20 دقيقة',
            ),
            const _StatusTile(
              name: 'أحمد',
              time: 'منذ ساعة',
            ),
          ],
        ),
        Positioned(
          left: 20,
          bottom: 20,
          child: FloatingActionButton(
            backgroundColor: fahadGold,
            foregroundColor: Colors.black,
            onPressed: () =>
                _addStatus(context),
            child: const Icon(
              Icons.camera_alt,
            ),
          ),
        ),
      ],
    );
  }

  void _addStatus(BuildContext context) {
    final controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: fahadPanel,
          title: const Text('إضافة حالة'),
          content: TextField(
            controller: controller,
            maxLines: 4,
            autofocus: true,
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
                backgroundColor: fahadGold,
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                await core.createStatus(
                  text: controller.text,
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
}

class _StatusTile extends StatelessWidget {
  final String name;
  final String time;

  const _StatusTile({
    required this.name,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: fahadGold,
            width: 2,
          ),
        ),
        child: const CircleAvatar(
          backgroundColor: fahadPanel,
          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(time),
    );
  }
}

/* ============================================================
   📢 CHANNELS
   ============================================================ */

class ChannelsPage extends StatelessWidget {
  final AlWazirCore core;

  const ChannelsPage({
    super.key,
    required this.core,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        ...core.channels.map(
          (channel) => _ChannelCard(
            channel: channel,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChannelPage(
                    core: core,
                    channelId: channel.id,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: fahadPanel,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: fahadGold,
              foregroundColor: Colors.black,
              child: Icon(
                Icons.wifi_tethering,
              ),
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
              color: fahadGold,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NearbyPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ChannelCard extends StatelessWidget {
  final AlWazirChannel channel;
  final VoidCallback onTap;

  const _ChannelCard({
    required this.channel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: fahadPanel,
      margin:
          const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(
          backgroundColor: fahadGold,
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
                color: fahadGold,
              ),
            ],
          ],
        ),
        subtitle: Text(
          channel.description,
        ),
        trailing: Icon(
          channel.following
              ? Icons.notifications
              : Icons.notifications_none,
          color: fahadGold,
        ),
      ),
    );
  }
}

class ChannelPage extends StatelessWidget {
  final AlWazirCore core;
  final String channelId;

  const ChannelPage({
    super.key,
    required this.core,
    required this.channelId,
  });

  @override
  Widget build(BuildContext context) {
    final channel = core.channels.firstWhere(
      (e) => e.id == channelId,
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: fahadBackground,
        appBar: AppBar(
          backgroundColor: fahadAppBar,
          title: Text(channel.name),
          actions: [
            IconButton(
              onPressed: () async {
                await core.toggleFollowChannel(
                  channel.id,
                );
              },
              icon: Icon(
                channel.following
                    ? Icons.notifications
                    : Icons.notifications_none,
                color: fahadGold,
              ),
            ),
          ],
        ),
        body: AnimatedBuilder(
          animation: core,
          builder: (context, _) {
            final current = core.channels.firstWhere(
              (e) => e.id == channelId,
            );

            return ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Card(
                  color: fahadPanel,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: fahadGold,
                          foregroundColor: Colors.black,
                          child: Icon(Icons.pets),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            current.description,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (current.posts.isEmpty)
                  const _EmptyState(
                    icon: Icons.campaign_outlined,
                    title: 'لا توجد منشورات',
                    subtitle:
                        'سيتم عرض منشورات القناة هنا',
                  ),
                ...current.posts.reversed.map(
                  (post) => Card(
                    color: fahadPanel,
                    child: Padding(
                      padding:
                          const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          if (post.advertisement)
                            const Text(
                              'إعلان',
                              style: TextStyle(
                                color: fahadGold,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          Text(post.text),
                          const SizedBox(height: 8),
                          Text(
                            _formatTime(
                              post.createdAt,
                            ),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: fahadGold,
          foregroundColor: Colors.black,
          onPressed: () {
            _addPost(context, channel.id);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _addPost(
    BuildContext context,
    String id,
  ) {
    final controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: fahadPanel,
          title: const Text('منشور جديد'),
          content: TextField(
            controller: controller,
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
                backgroundColor: fahadGold,
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                await core.addChannelPost(
                  channelId: id,
                  text: controller.text,
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
}

/* ============================================================
   🐆 NEARBY — واجهة المرحلة الحالية
   ============================================================ */

class NearbyPage extends StatefulWidget {
  const NearbyPage({super.key});

  @override
  State<NearbyPage> createState() => _NearbyPageState();
}

class _NearbyPageState extends State<NearbyPage> {
  bool searching = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: fahadBackground,
        appBar: AppBar(
          backgroundColor: fahadAppBar,
          title: const Text('الاتصال القريب'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
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
                      color: fahadGold,
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.wifi_tethering,
                    color: fahadGold,
                    size: 55,
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
                const SizedBox(height: 10),
                const Text(
                  'Bluetooth + Wi-Fi Direct',
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: fahadGold,
                    foregroundColor: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      searching = !searching;
                    });
                  },
                  icon: Icon(
                    searching
                        ? Icons.stop
                        : Icons.search,
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

/* ============================================================
   ⚙️ SETTINGS
   ============================================================ */

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
        backgroundColor: fahadBackground,
        appBar: AppBar(
          backgroundColor: fahadAppBar,
          title: const Text('الإعدادات'),
        ),
        body: AnimatedBuilder(
          animation: core,
          builder: (context, _) {
            return ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _ProfileHeader(
                  account: core.account,
                  onTap: () {
                    _editProfile(context);
                  },
                ),
                const SizedBox(height: 12),
                _SettingsSection(
                  title: 'الحساب',
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.person_outline,
                        color: fahadGold,
                      ),
                      title: const Text('الملف الشخصي'),
                      subtitle: Text(
                        core.account.name.isEmpty
                            ? 'إضافة الاسم'
                            : core.account.name,
                      ),
                      onTap: () =>
                          _editProfile(context),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.language,
                        color: fahadGold,
                      ),
                      title: const Text('اللغة'),
                      subtitle: Text(
                        core.settings.language,
                      ),
                      onTap: () =>
                          _chooseLanguage(context),
                    ),
                  ],
                ),
                _SettingsSection(
                  title: 'الخصوصية والأمان',
                  children: [
                    _switchTile(
                      'إشعارات الرسائل',
                      Icons.notifications_none,
                      core.settings.notifications,
                      (value) async {
                        await core.updateSettings(
                          core.settings.copyWith(
                            notifications: value,
                          ),
                        );
                      },
                    ),
                    _switchTile(
                      'إيصالات القراءة',
                      Icons.done_all,
                      core.settings.readReceipts,
                      (value) async {
                        await core.updateSettings(
                          core.settings.copyWith(
                            readReceipts: value,
                          ),
                        );
                      },
                    ),
                    _switchTile(
                      'آخر ظهور',
                      Icons.visibility_outlined,
                      core.settings.lastSeen,
                      (value) async {
                        await core.updateSettings(
                          core.settings.copyWith(
                            lastSeen: value,
                          ),
                        );
                      },
                    ),
                    _switchTile(
                      'قفل التطبيق',
                      Icons.lock_outline,
                      core.settings.appLock,
                      (value) async {
                        await core.updateSettings(
                          core.settings.copyWith(
                            appLock: value,
                          ),
                        );
                      },
                    ),
                    _switchTile(
                      'قفل المحادثات',
                      Icons.lock_person_outlined,
                      core.settings.chatLock,
                      (value) async {
                        await core.updateSettings(
                          core.settings.copyWith(
                            chatLock: value,
                          ),
                        );
                      },
                    ),
                    _switchTile(
                      'التحقق بخطوتين',
                      Icons.verified_user_outlined,
                      core.settings.twoStepVerification,
                      (value) async {
                        await core.updateSettings(
                          core.settings.copyWith(
                            twoStepVerification: value,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                _SettingsSection(
                  title: 'التخزين',
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.storage_outlined,
                        color: fahadGold,
                      ),
                      title: const Text(
                        'إدارة التخزين',
                      ),
                      subtitle: const Text(
                        'البيانات المحلية محفوظة داخل التطبيق',
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _switchTile(
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      secondary: Icon(
        icon,
        color: fahadGold,
      ),
      title: Text(title),
      value: value,
      activeThumbColor: fahadGold,
      onChanged: onChanged,
    );
  }

  void _editProfile(BuildContext context) {
    final name = TextEditingController(
      text: core.account.name,
    );
    final phone = TextEditingController(
      text: core.account.phone,
    );
    final about = TextEditingController(
      text: core.account.about,
    );

    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: fahadPanel,
          title: const Text('الملف الشخصي'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(
                    labelText: 'الاسم',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: about,
                  decoration: const InputDecoration(
                    labelText: 'نبذة',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: fahadGold,
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                await core.saveAccount(
                  core.account.copyWith(
                    name: name.text.trim(),
                    phone: phone.text.trim(),
                    about: about.text.trim(),
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

  void _chooseLanguage(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: fahadPanel,
          title: const Text('اختر اللغة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              'العربية',
              'English',
            ]
                .map(
                  (language) => ListTile(
                    title: Text(language),
                    trailing:
                        core.settings.language ==
                                language
                            ? const Icon(
                                Icons.check,
                                color: fahadGold,
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
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final AlWazirAccount account;
  final VoidCallback onTap;

  const _ProfileHeader({
    required this.account,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: fahadPanel,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        leading: const CircleAvatar(
          radius: 30,
          backgroundColor: fahadGold,
          foregroundColor: Colors.black,
          child: Icon(
            Icons.person,
            size: 32,
          ),
        ),
        title: Text(
          account.name.isEmpty
              ? 'إضافة اسمك'
              : account.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          account.phone.isEmpty
              ? account.about
              : account.phone,
        ),
        trailing: const Icon(
          Icons.chevron_left,
          color: fahadGold,
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: fahadPanel,
      margin:
          const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              14,
              16,
              5,
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: fahadGold,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

/* ============================================================
   📞 CALL SCREEN
   ============================================================ */

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
  bool muted = false;
  bool speaker = false;

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
              const CircleAvatar(
                radius: 65,
                backgroundColor: fahadGold,
                foregroundColor: Colors.black,
                child: Icon(
                  Icons.person,
                  size: 70,
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
              const Spacer(),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  _CallButton(
                    icon: muted
                        ? Icons.mic_off
                        : Icons.mic,
                    label: 'كتم',
                    active: muted,
                    onTap: () {
                      setState(() {
                        muted = !muted;
                      });
                    },
                  ),
                  const SizedBox(width: 25),
                  _CallButton(
                    icon: Icons.call_end,
                    label: 'إنهاء',
                    danger: true,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 25),
                  _CallButton(
                    icon: speaker
                        ? Icons.volume_up
                        : Icons.volume_down,
                    label: 'مكبر',
                    active: speaker,
                    onTap: () {
                      setState(() {
                        speaker = !speaker;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final bool danger;
  final VoidCallback onTap;

  const _CallButton({
    required this.icon,
    required this.label,
    this.active = false,
    this.danger = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: danger
              ? Colors.redAccent
              : active
                  ? fahadGold
                  : fahadPanel,
          foregroundColor:
              danger || active
                  ? Colors.black
                  : Colors.white,
          child: IconButton(
            onPressed: onTap,
            icon: Icon(icon),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

/* ============================================================
   🔎 SEARCH
   ============================================================ */

class FahadSearchDelegate
    extends SearchDelegate<void> {
  final AlWazirCore core;

  FahadSearchDelegate(this.core);

  @override
  List<Widget>? buildActions(
    BuildContext context,
  ) {
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
  Widget? buildLeading(
    BuildContext context,
  ) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(
    BuildContext context,
  ) {
    final q = query.trim().toLowerCase();

    final results = core.chats.where(
      (chat) =>
          chat.name.toLowerCase().contains(q) ||
          chat.phone.toLowerCase().contains(q) ||
          chat.lastMessage
              .toLowerCase()
              .contains(q),
    );

    return Container(
      color: fahadBackground,
      child: ListView(
        children: results.map(
          (chat) {
            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: fahadGold,
                foregroundColor: Colors.black,
                child: Icon(Icons.person),
              ),
              title: Text(chat.name),
              subtitle: Text(chat.lastMessage),
              onTap: () {
                close(context, null);

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
            );
          },
        ).toList(),
      ),
    );
  }

  @override
  Widget buildSuggestions(
    BuildContext context,
  ) {
    return buildResults(context);
  }
}

/* ============================================================
   🧩 EMPTY STATE
   ============================================================ */

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
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 65,
              color: fahadGold,
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
                  backgroundColor: fahadGold,
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

/* ============================================================
   🕐 HELPERS
   ============================================================ */

String _formatTime(DateTime? time) {
  if (time == null) return '';

  final hour = time.hour;
  final minute =
      time.minute.toString().padLeft(2, '0');

  final period =
      hour >= 12 ? 'م' : 'ص';

  final displayHour =
      hour % 12 == 0 ? 12 : hour % 12;

  return '$displayHour:$minute $period';
}
