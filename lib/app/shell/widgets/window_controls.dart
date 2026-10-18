import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:window_manager/window_manager.dart';

/// أزرار النافذة الثلاثة: تصغير، تكبير/استعادة، إغلاق.
///
/// **لماذا ودجة مشتركة:** النافذة بلا إطار نظام (`TitleBarStyle.hidden`)،
/// فالأزرار من صنعنا لا من ويندوز. وكانت حبيسةَ شريط عنوان الشاشة الرئيسية،
/// فمن يفتح التطبيق ويقف عند تسجيل الدخول لا يجد سبيلاً إلى تصغير النافذة
/// ولا تكبيرها ولا إغلاقها — إلا بـ Alt+F4 أو من شريط المهام.
///
/// تتولّى بنفسها تتبُّعَ حالة التكبير والاستجابة لتغيّرها من خارجها (نقرٌ
/// مزدوج على شريط السحب، أو مفاتيح ويندوز) فتبقى الأيقونة مطابقة للواقع.
class WindowControls extends StatefulWidget {
  const WindowControls({
    this.onClose,
    this.foreground,
    this.height = AppDesktopSizes.titleBarHeight,
    super.key,
  });

  /// بديلٌ لإغلاقٍ مباشر — تستعمله الشاشة الرئيسية لتأكيد الخروج. وشاشات
  /// الدخول لا تمرّره: لا عمل يضيع هناك، فالتأكيد عرقلةٌ بلا مقابل.
  final Future<void> Function()? onClose;

  /// لون الأيقونات. يلزم تمريره فوق خلفية ملوّنة (لوحة العلامة في شاشة
  /// الدخول) وإلّا ذابت الأيقونة الداكنة في الأخضر.
  final Color? foreground;

  final double height;

  @override
  State<WindowControls> createState() => _WindowControlsState();
}

class _WindowControlsState extends State<WindowControls> with WindowListener {
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _sync();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowMaximize() => setState(() => _isMaximized = true);

  @override
  void onWindowUnmaximize() => setState(() => _isMaximized = false);

  Future<void> _sync() async {
    final max = await windowManager.isMaximized();
    if (mounted) setState(() => _isMaximized = max);
  }

  Future<void> _toggleMaximize() async {
    if (_isMaximized) {
      await windowManager.unmaximize();
    } else {
      await windowManager.maximize();
    }
  }

  Future<void> _close() async {
    final custom = widget.onClose;
    if (custom != null) {
      await custom();
      return;
    }
    await windowManager.close();
  }

  @override
  Widget build(BuildContext context) {
    // الأزرار في أعلى اليمين دائماً كعُرف ويندوز، مهما كانت لغة الواجهة.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _WinButton(
            icon: Icons.remove,
            tooltip: 'تصغير',
            height: widget.height,
            foreground: widget.foreground,
            onTap: windowManager.minimize,
          ),
          _WinButton(
            icon: _isMaximized ? Icons.filter_none : Icons.crop_square,
            tooltip: _isMaximized ? 'استعادة' : 'تكبير',
            height: widget.height,
            foreground: widget.foreground,
            onTap: _toggleMaximize,
          ),
          _WinButton(
            icon: Icons.close,
            tooltip: AppStrings.close,
            height: widget.height,
            foreground: widget.foreground,
            onTap: _close,
            isClose: true,
          ),
        ],
      ),
    );
  }
}

class _WinButton extends StatefulWidget {
  const _WinButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.height,
    this.foreground,
    this.isClose = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final double height;
  final Color? foreground;
  final bool isClose;

  @override
  State<_WinButton> createState() => _WinButtonState();
}

class _WinButtonState extends State<_WinButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final fg = widget.foreground ?? Theme.of(context).colorScheme.onSurface;
    const w = 46.0;

    return Tooltip(
      message: widget.tooltip,
      preferBelow: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: w,
            height: widget.height,
            color: _hovered
                ? (widget.isClose
                    ? const Color(0xFFC42B1C)
                    : fg.withValues(alpha: 0.12))
                : Colors.transparent,
            child: Icon(
              widget.icon,
              size: 14,
              color: _hovered && widget.isClose ? Colors.white : fg,
            ),
          ),
        ),
      ),
    );
  }
}
