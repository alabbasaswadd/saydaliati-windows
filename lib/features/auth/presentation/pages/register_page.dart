import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saydaliati/app/router/app_routes.dart';
import 'package:saydaliati/app/sync/data_sync_controller.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/session/session_controller.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/auth/auth_providers.dart';
import 'package:saydaliati/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:saydaliati/features/auth/presentation/widgets/phone_field.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';

/// العملة الأساسية ثابتة دائماً: الليرة السورية (تُبذر في الخادم) — لا تُختار عند التسجيل.

/// المحافظات السورية — المحافظة إجبارية عند التسجيل.
const List<String> _kGovernorates = [
  'دمشق',
  'ريف دمشق',
  'حلب',
  'حمص',
  'حماة',
  'اللاذقية',
  'طرطوس',
  'إدلب',
  'درعا',
  'السويداء',
  'القنيطرة',
  'دير الزور',
  'الرقة',
  'الحسكة',
];

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _pharmacy = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _userName = TextEditingController();
  final _password = TextEditingController();
  final _city = TextEditingController();
  final _address = TextEditingController();
  final _usdRate = TextEditingController();
  String _fullPhone = '';
  String? _governorate;
  bool _busy = false;
  bool _obscure = true;

  @override
  void dispose() {
    _pharmacy.dispose();
    _phone.dispose();
    _email.dispose();
    _userName.dispose();
    _password.dispose();
    _city.dispose();
    _address.dispose();
    _usdRate.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    try {
      final res = await ref.read(authRemoteDataSourceProvider).register(
            pharmacyName: _pharmacy.text.trim(),
            email: _email.text.trim(),
            phone: _fullPhone,
            userName: _userName.text.trim(),
            password: _password.text,
            governorate: _governorate ?? '',
            city: _city.text.trim(),
            address: _address.text.trim(),
            usdExchangeRate:
                double.tryParse(_usdRate.text.trim().replaceAll(',', '.')) ?? 0,
          );
      await ref.read(sessionControllerProvider.notifier).establish(
            token: res['token'] as String,
            userId: res['userId'] as String?,
            tenantId: res['tenantId'] as String?,
          );
      // Actual registration → pull the new pharmacy's data into the cache ONCE
      // (only automatic full sync besides manual refresh; never on app open).
      ref.read(dataSyncControllerProvider.notifier).syncAll();
    } catch (e) {
      if (mounted) showFailureSnackbar(context, mapExceptionToFailure(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: AppStrings.registerSubtitle,
      subtitle: 'املأ البيانات التالية لإنشاء حساب صيدليتك',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // اسم الصيدلية (إجباري)
            TextFormField(
              controller: _pharmacy,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: AppStrings.pharmacyNameField,
                prefixIcon: Icon(Icons.local_pharmacy_outlined),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? AppStrings.requiredField : null,
            ),
            const SizedBox(height: AppSpacing.md),
            // الهاتف أولاً (إجباري) مع رمز الدولة — سوريا افتراضياً
            PhoneField(
              controller: _phone,
              onChanged: (full) => _fullPhone = full,
            ),
            const SizedBox(height: AppSpacing.md),
            // البريد الإلكتروني (اختياري)
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: AppStrings.emailOptional,
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // اسم المستخدم (اختياري)
            TextFormField(
              controller: _userName,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: AppStrings.userNameOptional,
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // المحافظة (إجبارية)
            DropdownButtonFormField<String>(
              initialValue: _governorate,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'المحافظة',
                prefixIcon: Icon(Icons.map_outlined),
              ),
              items: [
                for (final g in _kGovernorates)
                  DropdownMenuItem(value: g, child: Text(g)),
              ],
              onChanged: (v) => setState(() => _governorate = v),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'المحافظة مطلوبة' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            // المدينة (اختيارية)
            TextFormField(
              controller: _city,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'المدينة (اختياري)',
                prefixIcon: Icon(Icons.location_city_outlined),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // العنوان (اختياري)
            TextFormField(
              controller: _address,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'العنوان (اختياري)',
                prefixIcon: Icon(Icons.home_outlined),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // سعر صرف الدولار مقابل الليرة السورية (إجباري): كم ل.س يساوي 1$.
            // يضبط عملة الدولار الثانوية؛ يمكن تعديله لاحقاً من شاشة العملات.
            TextFormField(
              controller: _usdRate,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'سعر صرف الدولار',
                hintText: 'كم ل.س يساوي 1\$ — مثلاً 135',
                prefixIcon: Icon(Icons.currency_exchange_outlined),
                suffixText: 'ل.س / 1\$',
              ),
              validator: (v) {
                final t = (v ?? '').trim();
                if (t.isEmpty) return 'سعر صرف الدولار مطلوب';
                final n = double.tryParse(t.replaceAll(',', '.'));
                if (n == null || n <= 0) return 'أدخل قيمة موجبة صحيحة';
                return null;
              },
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
                  (v == null || v.length < 6) ? 'كلمة المرور ٦ أحرف على الأقل' : null,
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
                  : const Text(AppStrings.registerCta),
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: _busy ? null : () => context.go(AppRoutes.login),
              child: const Text(AppStrings.haveAccountLogin),
            ),
          ],
        ),
      ),
    );
  }
}
