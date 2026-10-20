/// دور (Admin / مساعد صيدلي / أو دور مخصّص) مع رموز صلاحياته الحالية.
class AppRole {
  const AppRole({
    required this.id,
    required this.roleName,
    required this.description,
    required this.isSystem,
    required this.permissionCodes,
  });

  final String id;
  final String roleName;
  final String description;

  /// دور النظام (Admin) — صلاحياته ثابتة دائماً (كل الصلاحيات) ولا يُحذف
  /// ولا تُعدَّل صلاحياته؛ الخادم يرفض ذلك بصرف النظر عمّا تفعله الواجهة.
  final bool isSystem;
  final List<String> permissionCodes;
}
