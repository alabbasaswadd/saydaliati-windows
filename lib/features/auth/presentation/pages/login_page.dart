import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saydaliati/app/router/app_routes.dart';
import 'package:saydaliati/app/sync/data_sync_controller.dart';
import 'package:saydaliati/core/config/app_config.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/session/session_controller.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/auth/auth_providers.dart';
import 'package:saydaliati/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:saydaliati/features/auth/presentation/widgets/phone_field.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  String _fullPhone = '';
  bool _busy = false;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    // Public web demo: pre-fill the shared demo credentials (the phone field
    // prepends +963 → full 963999000000, matching the seeded demo pharmacy).
    if (AppConfig.demoMode) {
      _phone.text = AppConfig.demoPhoneLocal;
      _password.text = AppConfig.demoPassword;
    }
  }

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    try {
      final res = await ref.read(authRemoteDataSourceProvider).login(
            login: _fullPhone,
            password: _password.text,
          );
      await ref.read(sessionControllerProvider.notifier).establish(
            token: res['token'] as String,
            userId: res['userId'] as String?,
            tenantId: res['tenantId'] as String?,
          );
      // Actual login → pull this pharmacy's data into the cache ONCE. This is
      // the only automatic full sync (besides manual refresh); it never runs on
      // app open or reconnect. Fire-and-forget; the shell shows the first-load UI.
      ref.read(dataSyncControllerProvider.notifier).syncAll();
      // Router redirect takes over once authenticated.
    } catch (e) {
      if (mounted) showFailureSnackbar(context, mapExceptionToFailure(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: AppStrings.loginWelcome,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (AppConfig.demoMode) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'حساب تجريبي — البيانات مُعبّأة مسبقاً، اضغط «تسجيل الدخول».',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            PhoneField(
              controller: _phone,
              onChanged: (full) => _fullPhone = full,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _password,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: AppStrings.password,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? AppStrings.requiredField : null,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: _busy ? null : _submit,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              child: _busy
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text(AppStrings.signIn),
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: _busy ? null : () => context.go(AppRoutes.register),
              child: const Text(AppStrings.noAccountRegister),
            ),
          ],
        ),
      ),
    );
  }
}
