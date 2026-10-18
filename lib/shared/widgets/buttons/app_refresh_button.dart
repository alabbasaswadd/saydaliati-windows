import 'dart:async';

import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/errors/failure.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';

/// زرّ التحديث الموحَّد: يدور أثناء العمل ثم يُعلن انتهاءه.
///
/// **المشكلة التي يحلّها:** كانت كل شاشة تضع `IconButton(Icons.refresh)` يستدعي
/// `ref.invalidate(...)` ويعود فوراً. و`AsyncValue.when` يُبقي البيانات السابقة
/// أثناء إعادة الجلب (`skipLoadingOnRefresh`) — فلا يتغيّر على الشاشة شيء: لا
/// مؤشّر، ولا تعطيلٌ للزرّ، ولا إشعارٌ عند الوصول. وإن عادت البيانات كما هي —
/// وهو الغالب — بدا الزرّ معطَّلاً تماماً، فيُنقَر مرّاتٍ بلا طائل.
///
/// **ثلاثة أمور تجعله محسوساً:**
/// 1. الأيقونة تدور والزرّ معطَّل طوال العمل — فيُعرَف أن الطلب جارٍ.
/// 2. دورةٌ دُنيا [_minSpin] حتى لو عاد الجواب من الكاش في 20ms: وميضٌ أقصر من
///    ذلك لا تلتقطه العين، فيبقى الإحساس بأن النقرة ذهبت سدىً.
/// 3. إشعار «تم التحديث» أعلى الشاشة عند النجاح، ورسالة الخطأ عند الفشل —
///    فللنقرة نتيجةٌ معلنة في الحالتين.
///
/// **مرِّر دالّةً تُنتظَر** (`() => ref.refresh(p.future)`) لا `invalidate`
/// وحدها: الأولى تدور إلى أن تصل البيانات فعلاً، والثانية تدور دورةً شكليّة.
class AppRefreshButton extends StatefulWidget {
  const AppRefreshButton({
    required this.onRefresh,
    this.tooltip = AppStrings.refreshData,
    this.iconSize,
    this.successMessage = 'تم التحديث',
    super.key,
  });

  /// عمل التحديث. يُنتظَر إن أعاد `Future`.
  final FutureOr<void> Function() onRefresh;

  final String tooltip;
  final double? iconSize;

  /// إشعار النجاح — `null` يكتمه (حين تُظهر الشاشة أثر التحديث بنفسها).
  final String? successMessage;

  @override
  State<AppRefreshButton> createState() => _AppRefreshButtonState();
}

class _AppRefreshButtonState extends State<AppRefreshButton>
    with SingleTickerProviderStateMixin {
  /// أقصر زمنٍ يبقى فيه الدوران مرئياً.
  static const _minSpin = Duration(milliseconds: 600);

  bool _busy = false;
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    if (_busy) return;
    setState(() => _busy = true);
    _spin.repeat();

    final clock = Stopwatch()..start();
    Object? failure;
    try {
      await widget.onRefresh();
    } catch (error) {
      failure = error;
    }

    final remaining = _minSpin - clock.elapsed;
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }
    if (!mounted) return;

    _spin
      ..stop()
      ..value = 0;
    setState(() => _busy = false);

    if (failure != null) {
      AppSnackbar.error(
        context,
        failure is NetworkFailure || failure is TimeoutFailure
            ? AppStrings.noInternetToRefresh
            : failure is Failure
                ? failure.displayMessage
                : AppStrings.errorDefault,
      );
      return;
    }
    final success = widget.successMessage;
    if (success != null) AppSnackbar.success(context, success);
  }

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      Icons.refresh,
      size: widget.iconSize,
      // اللون أثناء الدوران يفصل «يعمل» عن «ساكن» لمن لا يلتقط الحركة.
      color: _busy ? Theme.of(context).colorScheme.primary : null,
    );

    return IconButton(
      tooltip: _busy ? AppStrings.refreshingData : widget.tooltip,
      onPressed: _busy ? null : _run,
      icon: _busy ? RotationTransition(turns: _spin, child: icon) : icon,
    );
  }
}
