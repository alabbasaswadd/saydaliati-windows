/// مستخدم ضمن الصيدلية الحالية (مالك أو مساعد صيدلي أو أي دور آخر).
class StaffUser {
  const StaffUser({
    required this.id,
    required this.userName,
    required this.email,
    required this.phone,
    required this.isActive,
    this.roleId,
    this.roleName,
  });

  final String id;
  final String userName;
  final String email;
  final String phone;
  final bool isActive;
  final String? roleId;
  final String? roleName;
}
