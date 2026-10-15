import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:window_manager/window_manager.dart';

/// يُبقي أسعار الصرف في التطبيق حديثة بدل أن تبقى على ما حُمِّل عند الإقلاع.
///
/// المشكلة التي يحلّها: جهاز الكاشير يُفتح صباحاً فتُحمَّل العملات مرّة واحدة
/// وتبقى في الذاكرة طوال اليوم. يُعدَّل سعر الصرف من جهاز آخر، فيستمر الكاشير
/// بالسعر القديم — تُعرض الأسعار بقيمة غير صحيحة، ويرى الصيدلي رقماً لا يطابق
/// ما يحصل فعلياً في الدفتر.
///
/// ثلاث لحظات للتحديث، تغطّي ما يقع عملياً:
///  * كل [_interval] — السقف الأعلى لقِدَم السعر.
///  * عند عودة التركيز للنافذة — الصيدلي بدّل لجهاز آخر ثم عاد.
///  * عند فتح شاشة فاتورة ([refreshIfStale]) — اللحظة التي يهمّ فيها السعر.
class CurrencyFreshness extends ConsumerStatefulWidget {
  const CurrencyFreshness({required this.child, super.key});

  final Widget child;

  /// أقصى عمر مسموح للسعر قبل إعادة تحميله.
  static const Duration maxAge = Duration(minutes: 5);

  static DateTime? _lastRefresh;

  /// يعيد تحميل العملات إن تجاوز عمر النسخة الحالية [maxAge].
  ///
  /// تستدعيه شاشات الفواتير عند فتحها. رخيص: لا شيء يحدث إن كانت حديثة.
  static void refreshIfStale(WidgetRef ref) {
    final last = _lastRefresh;
    if (last != null && DateTime.now().difference(last) < maxAge) return;
    refreshNow(ref);
  }

  /// إعادة تحميل فورية بلا شرط (زرّ التحديث، أو بعد تعديل سعر).
  static void refreshNow(WidgetRef ref) {
    _lastRefresh = DateTime.now();
    ref.invalidate(currenciesProvider);
  }

  @override
  ConsumerState<CurrencyFreshness> createState() => _CurrencyFreshnessState();
}

class _CurrencyFreshnessState extends ConsumerState<CurrencyFreshness>
    with WindowListener {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    CurrencyFreshness._lastRefresh = DateTime.now();
    windowManager.addListener(this);
    _timer = Timer.periodic(CurrencyFreshness.maxAge, (_) {
      if (mounted) CurrencyFreshness.refreshNow(ref);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    windowManager.removeListener(this);
    super.dispose();
  }

  /// عاد المستخدم لنافذة التطبيق — قد يكون عدّل السعر في مكان آخر للتوّ.
  @override
  void onWindowFocus() {
    if (mounted) CurrencyFreshness.refreshIfStale(ref);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
