/// Notification kinds — mirror the backend `NotificationTypeEnum` (sent as int).
/// The UI distinguishes [system] (app/platform notices) from business types.
enum NotificationType {
  system(1),
  sale(2),
  purchase(3),
  stock(4),
  expiry(5),
  account(6),
  general(7),
  video(8);

  const NotificationType(this.value);

  final int value;

  static NotificationType fromValue(int v) => NotificationType.values.firstWhere(
        (t) => t.value == v,
        orElse: () => NotificationType.general,
      );

  bool get isSystem => this == NotificationType.system;
  bool get isVideo => this == NotificationType.video;
}

/// An in-app notification shown in the notification center.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdOn,
    this.data = '',
  });

  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdOn;

  /// Optional routing payload. For a [NotificationType.video] notification this
  /// holds the video URL (e.g. a YouTube link) to open on tap.
  final String data;

  /// The launchable URL carried by this notification, or null if [data] isn't
  /// an http(s) link.
  String? get linkUrl {
    final d = data.trim();
    if (d.startsWith('http://') || d.startsWith('https://')) return d;
    return null;
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
        id: json['id'] as String,
        type: NotificationType.fromValue((json['type'] as num?)?.toInt() ?? 7),
        title: (json['title'] as String?) ?? '',
        body: (json['body'] as String?) ?? '',
        isRead: (json['isRead'] as bool?) ?? false,
        createdOn:
            DateTime.tryParse((json['createdOn'] as String?) ?? '')?.toLocal() ??
                DateTime.now(),
        data: (json['data'] as String?) ?? '',
      );

  AppNotification copyWith({bool? isRead}) => AppNotification(
        id: id,
        type: type,
        title: title,
        body: body,
        isRead: isRead ?? this.isRead,
        createdOn: createdOn,
        data: data,
      );
}
