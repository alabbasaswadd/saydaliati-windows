import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/features/accounts/account_providers.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/debts/debt_providers.dart';
import 'package:saydaliati/features/roles/roles_providers.dart';
import 'package:saydaliati/features/users/user_providers.dart';
import 'package:saydaliati/features/vouchers/voucher_providers.dart';

part 'auto_refresh_service.g.dart';

/// مدة التحديث التلقائي الافتراضية — 5 دقائق.
const _kRefreshInterval = Duration(minutes: 5);

/// يُعيد تحميل البيانات المالية والإدارية كل 5 دقائق تلقائياً ما دام التطبيق
/// مفتوحاً، دون الحاجة لأي تدخّل من المستخدم.
///
/// البيانات الثقيلة (الأدوية/المخزون) تُحدَّث بالمزامنة الكاملة [DataSyncController]
/// ولا تُكرَّر هنا — ما يُحدَّث هنا فقط ما يتغيّر بكثرة خلال ساعات العمل.
@Riverpod(keepAlive: true)
class AutoRefreshService extends _$AutoRefreshService {
  Timer? _timer;

  @override
  void build() {
    _timer?.cancel();
    _timer = Timer.periodic(_kRefreshInterval, (_) => _refresh());
    ref.onDispose(() => _timer?.cancel());
  }

  void _refresh() {
    ref.invalidate(currenciesProvider);
    ref.invalidate(accountsListProvider);
    ref.invalidate(accountStatementProvider);
    ref.invalidate(staffUsersProvider);
    ref.invalidate(rolesListProvider);
    ref.invalidate(vouchersListProvider);
    ref.invalidate(customerDebtsProvider);
    ref.invalidate(supplierDebtsProvider);
  }

  /// تحديث فوري (يمكن استدعاؤه يدوياً من أي مكان).
  void refreshNow() => _refresh();
}
