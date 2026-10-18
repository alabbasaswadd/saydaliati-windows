import 'package:flutter/material.dart';

/// زرّ الإضافة الموحَّد: **أيقونة واسمٌ صريح** لما يُضاف.
///
/// **المشكلة التي يحلّها:** كانت أكثر الشاشات تضع `+` مجرّدة في شريط العنوان،
/// اسمُها مخبّأ في تلميحٍ لا يظهر إلّا بوقوف المؤشّر فوقه ثانيةً كاملة — ولا
/// يظهر إطلاقاً لمن يعمل باللمس. فمن يبحث عن «إضافة مورّد» يرى علامةً بلا
/// معنى بين أيقوناتٍ أخرى متشابهة.
///
/// وزرٌّ ممتلئ لا أيقونة: الإضافة هي الفعل الأساسيّ في شاشات البيانات، وشكلُه
/// يجب أن يقول ذلك.
class AddEntityButton extends StatelessWidget {
  const AddEntityButton({
    required this.label,
    required this.onPressed,
    this.icon = Icons.add,
    this.tooltip,
    super.key,
  });

  /// ما يُضاف صريحاً: «إضافة مورّد»، «إضافة دواء»…
  final String label;
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
    final tip = tooltip;
    return tip == null ? button : Tooltip(message: tip, child: button);
  }
}
