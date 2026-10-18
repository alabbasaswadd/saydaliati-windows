import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/session/session_controller.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/auth/auth_providers.dart';
import 'package:saydaliati/shared/widgets/buttons/app_refresh_button.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// الملف الشخصي — هوية المستخدم والصيدلية، وتسجيل الخروج.
///
/// تسجيل الخروج **هنا وحده**: كان مكرَّراً في الإعدادات أيضاً، والتكرار في
/// فعلٍ لا رجعة فيه يجعل مكانه غير متوقَّع — فيُنقَر سهواً مَن يبحث عن إعداد.
/// ومكانه الطبيعي شاشة الهوية لا شاشة التفضيلات.
class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final ok = await showConfirmationDialog(
      context,
      title: AppStrings.logout,
      message: AppStrings.logoutConfirm,
      confirmLabel: AppStrings.logout,
      icon: Icons.logout,
      destructive: true,
    );
    if (!ok) return;
    await ref.read(sessionControllerProvider.notifier).clear();
    // تحويل الراوتر يأخذ المستخدم إلى شاشة الدخول.
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.accountTitle),
        actions: [
          AppRefreshButton(
            onRefresh: () => ref.refresh(currentUserProvider.future),
          ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(
          e,
          onRetry: () => ref.invalidate(currentUserProvider),
        ),
        data: (me) => _body(context, ref, me),
      ),
    );
  }

  Widget _body(BuildContext context, WidgetRef ref, Map<String, dynamic> me) {
    final pharmacy = _text(me['pharmacyName']);
    final userName = _text(me['userName']);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _Identity(
          pharmacy: pharmacy.isNotEmpty ? pharmacy : AppStrings.appName,
          userName: userName,
        ),
        const SizedBox(height: AppSpacing.lg),
        Card(
          child: Column(
            children: [
              _InfoRow(
                icon: Icons.local_pharmacy_outlined,
                label: AppStrings.pharmacyNameField,
                value: pharmacy,
              ),
              const Divider(height: 1),
              _InfoRow(
                icon: Icons.phone_outlined,
                label: AppStrings.phoneField,
                value: _text(me['phone']),
              ),
              const Divider(height: 1),
              _InfoRow(
                icon: Icons.email_outlined,
                label: AppStrings.email,
                value: _text(me['email']),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        _LogoutButton(onPressed: () => _logout(context, ref)),
      ],
    );
  }

  static String _text(Object? v) => v?.toString().trim() ?? '';
}

/// الصورة الرمزية واسم الصيدلية والمستخدم.
class _Identity extends StatelessWidget {
  const _Identity({required this.pharmacy, required this.userName});

  final String pharmacy;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
            child: Icon(Icons.person, size: 44, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            pharmacy,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (userName.isNotEmpty)
            Text(
              userName,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
            ),
        ],
      ),
    );
  }
}

/// سطر معلومة: الحقل الفارغ يُعرَض «—» لا فراغاً، فلا يبدو السطر مقطوعاً.
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon),
        title: Text(label, style: const TextStyle(fontSize: 13)),
        subtitle: Text(
          value.isEmpty ? '—' : value,
          textDirection: value.isEmpty ? null : TextDirection.ltr,
        ),
      );
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // لون الخطر من نظام الألوان لا ثابتاً — فيتبع السمة الفاتحة والداكنة.
    final danger = Theme.of(context).colorScheme.error;
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: danger,
        foregroundColor: Theme.of(context).colorScheme.onError,
        minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
      ),
      onPressed: onPressed,
      icon: const Icon(Icons.logout),
      label: const Text(AppStrings.logout),
    );
  }
}
