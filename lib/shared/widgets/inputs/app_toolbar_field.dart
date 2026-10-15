import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// الغلاف البصري الموحّد لعناصر شريط أدوات الفاتورة (التاريخ، العملة، العميل،
/// الصندوق/الحساب، طريقة الدفع).
///
/// الغاية منه حلّ سبب «ثقل» الشريط العلوي: كانت الحقول تُبنى بثلاث طرق مختلفة
/// (شريحة بحدّ، `InputDecorator` بارتفاع الحقل الكامل، و`FilterChip`) فاختلفت
/// ارتفاعاتها وزواياها وأحجام أيقوناتها على السطر نفسه. هنا تُجمع كلها على:
///
/// * ارتفاع واحد [AppSizes.toolbarFieldHeight] ومحاذاة رأسية واحدة،
/// * زاوية واحدة خفيفة [toolbarFieldRadius] وحدّ رفيع محايد واضح،
/// * أيقونة بادئة/لاحقة بحجم [AppSizes.iconXs] بلون ثانوي هادئ،
/// * تسمية صغيرة (labelMedium) داخل فتحة الحدّ، وقيمة بوزن عادي.
///
/// الأخضر يبقى لون التفاعل: يظهر على الحدّ والأيقونة والتسمية عند التمرير
/// والتركيز فقط، فتبقى الحالة الساكنة خفيفة ومحايدة من دون إضعاف التباين.
///
/// مقصور على شريط أدوات الفاتورة — لا يغيّر `inputDecorationTheme` العام ولا
/// شكل أي حقل في بقية الشاشات.
class AppToolbarField extends StatefulWidget {
  const AppToolbarField({
    required this.icon,
    this.label,
    this.value,
    this.placeholder,
    this.trailing,
    this.onTap,
    this.tooltip,
    this.width,
    super.key,
  });

  /// الأيقونة البادئة — دلالة الحقل (تاريخ/عملة/عميل…).
  final IconData icon;

  /// التسمية الصغيرة داخل فتحة الحدّ.
  final String? label;

  /// القيمة الحالية؛ `null` أو فارغة تعني لا اختيار بعد فيُعرض [placeholder].
  final String? value;

  /// نصّ الحالة الفارغة — يُعرض بلون ثانوي أقل بروزاً من القيمة الفعلية.
  final String? placeholder;

  /// عنصر نهاية الحقل (بحث/سهم قائمة/مسح الاختيار). استخدم [toolbarTrailingIcon]
  /// للأيقونات حتى تبقى بالحجم واللون نفسيهما.
  final Widget? trailing;

  /// نقرة فتح المنتقي. اتركه `null` حين يتكفّل الأب بالنقر (مثل
  /// `PopupMenuButton` الذي يغلّف الحقل) — يبقى تأثير التمرير عاملاً.
  final VoidCallback? onTap;

  final String? tooltip;

  /// عرض ثابت للحقل. مطلوب داخل [Wrap]: الحقل مبنيّ على [InputDecorator] الذي
  /// يتمدّد لكامل العرض المتاح كأي حقل إدخال، فبلا عرض محدّد يبتلع السطر كلّه.
  /// الحقول التي يغلّفها الأب بـ`SizedBox` تتركه `null`.
  final double? width;

  @override
  State<AppToolbarField> createState() => _AppToolbarFieldState();
}

class _AppToolbarFieldState extends State<AppToolbarField> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final semantic = context.semantic;
    final primary = scheme.primary;

    final idleBorder = toolbarFieldBorderColor(context);
    final borderColor = _focused
        ? primary
        : _hovered
            ? primary.withValues(alpha: 0.45)
            : idleBorder;
    final borderWidth = _focused ? 1.4 : 1.0;

    final mutedIcon = semantic.textSecondary.withValues(alpha: 0.85);
    final iconColor = (_focused || _hovered) ? primary : mutedIcon;
    final labelColor =
        _focused ? primary : semantic.textSecondary.withValues(alpha: 0.9);

    final hasValue = widget.value != null && widget.value!.isNotEmpty;
    final text = hasValue ? widget.value! : (widget.placeholder ?? '');

    OutlineInputBorder border() => OutlineInputBorder(
          borderRadius: toolbarFieldRadius,
          borderSide: BorderSide(color: borderColor, width: borderWidth),
        );

    // ارتفاع ثابت لا حدّ أدنى: عناصر الشريط كلها (حقول ومفتاح «وصفة طبية»)
    // تأخذ القيمة نفسها حرفياً فتتطابق حوافها العليا والسفلى بلا تفاوت.
    final field = SizedBox(
      height: AppSizes.toolbarFieldHeight,
      child: InputDecorator(
        isFocused: _focused,
        isHovering: _hovered,
        decoration: InputDecoration(
          labelText: widget.label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,
          filled: true,
          fillColor: scheme.surface,
          // التمرير يُقرأ من الحدّ والأيقونة، لا من تعبئة إضافية خلف النص.
          hoverColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm + 2,
            vertical: AppSpacing.sm,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
            child: Icon(widget.icon, size: AppSizes.iconXs, color: iconColor),
          ),
          // بلا هذه القيود يفرض الحقل مربّع لمس 48px فيرتفع عن بقية الشريط.
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: widget.trailing == null
              ? null
              : Padding(
                  padding:
                      const EdgeInsetsDirectional.only(start: AppSpacing.xs),
                  child: widget.trailing,
                ),
          suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          labelStyle: theme.textTheme.labelMedium?.copyWith(color: labelColor),
          floatingLabelStyle:
              theme.textTheme.labelMedium?.copyWith(color: labelColor),
          border: border(),
          enabledBorder: border(),
          focusedBorder: border(),
          disabledBorder: border(),
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.25,
            // القيمة بالأسود الصريح (أعلى تباين ممكن) — شاشة إدخال سريع تُقرأ
            // قيمها بلمحة؛ نصّ الحالة الفارغة وحده يبقى ثانوياً.
            color: hasValue
                ? toolbarFieldTextColor(context)
                : semantic.textSecondary,
          ),
        ),
      ),
    );

    final interactive = widget.onTap == null
        ? field
        : InkWell(
            borderRadius: toolbarFieldRadius,
            onTap: widget.onTap,
            onFocusChange: (v) => setState(() => _focused = v),
            // الحالات تُعبَّر عنها بالحدّ واللون أعلاه، فلا حاجة لطبقات تلوين
            // فوق الحقل (تُظهر تعبئة رمادية ثقيلة فوق الخلفية البيضاء).
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: field,
          );

    final hoverable = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: interactive,
    );

    final sized = widget.width == null
        ? hoverable
        : SizedBox(width: widget.width, child: hoverable);

    if (widget.tooltip == null) return sized;
    return Tooltip(message: widget.tooltip!, child: sized);
  }
}

/// لون نصّ عناصر شريط الأدوات — أسود صريح في الثيم الفاتح، ولون السطح المقابل
/// في الداكن (الأسود عليه غير مقروء).
Color toolbarFieldTextColor(BuildContext context) {
  final theme = Theme.of(context);
  return theme.brightness == Brightness.light
      ? Colors.black
      : theme.colorScheme.onSurface;
}

/// أيقونة نهاية حقل بحجم ولون موحّدين — تبقى أخفّ من الأيقونة البادئة حتى لا
/// يتنافس طرفا الحقل بصرياً.
Widget toolbarTrailingIcon(BuildContext context, IconData icon) => Icon(
      icon,
      size: AppSizes.iconXs,
      color: context.semantic.textSecondary.withValues(alpha: 0.65),
    );

/// زاوية عناصر شريط الأدوات — استدارة خفيفة جداً تُبقي الحقل مستطيلاً واضح
/// الإطار بدل أن يبدو شريحة أو زراً.
const BorderRadius toolbarFieldRadius = AppRadius.brXs;

/// حدّ عناصر شريط الأدوات — رمادي محايد (بلا ميل أخضر) بتباين ظاهر يرسم إطار
/// الحقل بوضوح على الخلفية البيضاء.
Color toolbarFieldBorderColor(BuildContext context) => Color.alphaBlend(
      context.semantic.textSecondary.withValues(alpha: 0.40),
      Theme.of(context).colorScheme.surface,
    );
