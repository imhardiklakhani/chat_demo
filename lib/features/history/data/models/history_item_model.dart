class HistoryItemModel {
  final String fullName;
  final String lastMessage;
  final String avatarUrl;
  final String timeLabel;
  final int unreadCount;

  HistoryItemModel({
    required this.fullName,
    required this.lastMessage,
    required this.avatarUrl,
    required this.timeLabel,
    required this.unreadCount,
  });

  factory HistoryItemModel.fromApi(Map<String, dynamic> json) {
    final fullName = json['user']['fullName'] as String;
    final initial = fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';

    return HistoryItemModel(
      fullName: fullName,
      lastMessage: json['body'] as String,
      avatarUrl:
      'https://dummyimage.com/300x300/000/fff&text=$initial',
      timeLabel: _randomTime(),
      unreadCount: _randomUnread(),
    );
  }

  static String _randomTime() {
    final times = ['2 min ago', '5 min ago', '10 min ago', '1 hour ago'];
    times.shuffle();
    return times.first;
  }

  static int _randomUnread() {
    return DateTime.now().millisecond % 4; // 0–3
  }
}