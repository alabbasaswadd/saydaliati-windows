/// صلاحيات المستخدم الحالي — مُستخلَصة من استجابة `/auth/me` (`roleId`,
/// `roleName`, `permissions`)، لا نداء شبكة مستقل: `/auth/me` يحمل كل ما
/// يلزم في استجابة واحدة، فتكرار الطلب هنا زائد.
class CurrentUserPermissions {
  const CurrentUserPermissions({
    required this.roleId,
    required this.roleName,
    required this.codes,
  });

  final String? roleId;
  final String? roleName;
  final Set<String> codes;

  bool has(String code) => codes.contains(code);

  static const CurrentUserPermissions empty =
      CurrentUserPermissions(roleId: null, roleName: null, codes: {});

  factory CurrentUserPermissions.fromMe(Map<String, dynamic> me) {
    final raw = me['permissions'];
    final codes = raw is List
        ? raw.map((e) => e.toString()).toSet()
        : <String>{};
    return CurrentUserPermissions(
      roleId: me['roleId']?.toString(),
      roleName: me['roleName']?.toString(),
      codes: codes,
    );
  }
}
