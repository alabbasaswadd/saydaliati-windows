/// عنصر من كتالوج الصلاحيات الثابت على مستوى النظام (`GET /Permissions`).
class PermissionItem {
  const PermissionItem({
    required this.id,
    required this.code,
    required this.module,
    required this.descriptionAr,
  });

  final String id;
  final String code;
  final String module;
  final String descriptionAr;
}
