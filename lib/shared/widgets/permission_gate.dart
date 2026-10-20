import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/permissions/permission_providers.dart';

/// يُظهر [child] فقط إن ملك المستخدم الحالي [permission]؛ وإلا [fallback]
/// (افتراضياً لا شيء) — لإخفاء/تعطيل الأزرار والإجراءات الحسّاسة.
class PermissionGate extends ConsumerWidget {
  const PermissionGate({
    required this.permission,
    required this.child,
    this.fallback,
    super.key,
  });

  final String permission;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allowed = ref.hasPermission(permission);
    return allowed ? child : (fallback ?? const SizedBox.shrink());
  }
}
