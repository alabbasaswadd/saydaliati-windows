import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/session/session_controller.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/auth/auth_providers.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  late Future<Map<String, dynamic>> _me;

  @override
  void initState() {
    super.initState();
    _me = ref.read(authRemoteDataSourceProvider).me();
  }

  Future<void> _logout() async {
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
    // Router redirect sends the user to the login screen.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.accountTitle)),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _me,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const LoadingState();
          }
          final m = snap.data ?? const {};
          final pharmacy = (m['pharmacyName'] as String?) ?? '';
          final userName = (m['userName'] as String?) ?? '';
          final email = (m['email'] as String?) ?? '';
          final phone = (m['phone']?.toString() ?? '');

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                      child: Icon(Icons.person,
                          size: 44, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(pharmacy.isNotEmpty ? pharmacy : AppStrings.appName,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    if (userName.isNotEmpty)
                      Text(userName,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: theme.hintColor)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Card(
                child: Column(
                  children: [
                    _row(Icons.local_pharmacy_outlined, AppStrings.pharmacyNameField, pharmacy),
                    const Divider(height: 1),
                    _row(Icons.phone_outlined, AppStrings.phoneField, phone),
                    const Divider(height: 1),
                    _row(Icons.email_outlined, AppStrings.email,
                        email.isEmpty ? '—' : email),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text(AppStrings.logout),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) => ListTile(
        leading: Icon(icon),
        title: Text(label, style: const TextStyle(fontSize: 13)),
        subtitle: Text(value, textDirection: TextDirection.ltr),
      );
}
