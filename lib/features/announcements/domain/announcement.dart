import 'package:flutter/material.dart';

/// Announcement kinds — mirror the backend `AnnouncementTypeEnum` (sent as int).
/// Each kind carries its own icon/color/label so the popup styles itself.
enum AnnouncementType {
  system(1),
  info(2),
  tip(3),
  update(4),
  warning(5);

  const AnnouncementType(this.value);

  final int value;

  static AnnouncementType fromValue(int v) => AnnouncementType.values.firstWhere(
        (t) => t.value == v,
        orElse: () => AnnouncementType.info,
      );

  /// Arabic label shown in the popup header chip.
  String get label => switch (this) {
        AnnouncementType.system => 'تنويه النظام',
        AnnouncementType.info => 'معلومة',
        AnnouncementType.tip => 'فائدة',
        AnnouncementType.update => 'جديد',
        AnnouncementType.warning => 'تنبيه مهم',
      };

  IconData get icon => switch (this) {
        AnnouncementType.system => Icons.campaign_rounded,
        AnnouncementType.info => Icons.info_rounded,
        AnnouncementType.tip => Icons.lightbulb_rounded,
        AnnouncementType.update => Icons.auto_awesome_rounded,
        AnnouncementType.warning => Icons.warning_amber_rounded,
      };

  /// Accent color used for the header, icon and divider.
  Color get color => switch (this) {
        AnnouncementType.system => const Color(0xFF2E7D6B), // teal — matches brand
        AnnouncementType.info => const Color(0xFF2563EB), // blue
        AnnouncementType.tip => const Color(0xFFF59E0B), // amber
        AnnouncementType.update => const Color(0xFF16A34A), // green
        AnnouncementType.warning => const Color(0xFFEA580C), // orange
      };
}

/// A one-time announcement fetched on app open and shown once, then acknowledged.
class Announcement {
  const Announcement({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.data = '',
  });

  final String id;
  final AnnouncementType type;
  final String title;
  final String body;

  /// Optional payload (e.g. an http(s) link to open on tap).
  final String data;

  /// The launchable URL carried by this announcement, or null if not a link.
  String? get linkUrl {
    final d = data.trim();
    if (d.startsWith('http://') || d.startsWith('https://')) return d;
    return null;
  }

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        id: json['id'] as String,
        type: AnnouncementType.fromValue((json['type'] as num?)?.toInt() ?? 2),
        title: (json['title'] as String?) ?? '',
        body: (json['body'] as String?) ?? '',
        data: (json['data'] as String?) ?? '',
      );
}
