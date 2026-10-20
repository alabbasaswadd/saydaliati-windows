/// رموز الصلاحيات التي تتحقّق منها الواجهة — مرآة جزئية لكتالوج الخادم
/// (`PermissionCatalogSeeder.cs`). ليست كل الرموز هنا، فقط ما تحتاج الواجهة
/// فحصه فعلاً (بوابات التنقّل والإجراءات)؛ البقية يتحقّق منها الخادم فقط.
abstract final class PermissionCodes {
  const PermissionCodes._();

  static const String usersView = 'users.view';
  static const String usersCreate = 'users.create';
  static const String usersUpdate = 'users.update';
  static const String usersDeactivate = 'users.deactivate';

  static const String rolesView = 'roles.view';
  static const String rolesManage = 'roles.manage';
}
