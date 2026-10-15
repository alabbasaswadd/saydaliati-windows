import 'package:flutter/widgets.dart';

/// تابٌّ مفتوح على مستوى التطبيق — له **هويّة ثابتة وحياة مستقلّة**.
///
/// الهويّة هي [id] لا المسار: التابّ يُولَد فارغاً ثم يحمل صفحةً يختارها
/// المستخدم، وقد يحمل غيرها بعدها — وهو هو نفسه طوال ذلك. (المسار لو كان
/// الهويّة لصار كل انتقال تابّاً جديداً، ولاستحال وجود تابّ فارغ.)
@immutable
class AppTab {
  const AppTab({
    required this.id,
    this.location,
    this.title,
    this.icon,
    this.branchIndex,
  });

  /// هويّة التابّ — تبقى مع تغيّر صفحته.
  final String id;

  /// الصفحة المعروضة فيه. `null` = تابّ جديد لم يختر صاحبه صفحته بعد.
  final String? location;

  final String? title;
  final IconData? icon;

  /// فرع الشريط الجانبي الذي يملك [location] — للانتقال السريع الذي يُظهر
  /// الصفحة المحفوظة بلا إعادة بناء.
  final int? branchIndex;

  bool get isBlank => location == null;

  AppTab copyWith({
    String? location,
    String? title,
    IconData? icon,
    int? branchIndex,
  }) =>
      AppTab(
        id: id,
        location: location ?? this.location,
        title: title ?? this.title,
        icon: icon ?? this.icon,
        branchIndex: branchIndex ?? this.branchIndex,
      );

  @override
  bool operator ==(Object other) => other is AppTab && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
