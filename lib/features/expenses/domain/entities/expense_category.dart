/// تصنيف مصروف (إيجار/كهرباء/رواتب...) — `parentId` و `accountId` اختياريان
/// دوماً؛ لا ربط تلقائي بحساب (راجع EXPENSES_PLAN.md §0.3).
class ExpenseCategory {
  const ExpenseCategory({
    required this.id,
    required this.name,
    this.parentId,
    required this.isSystem,
    required this.isActive,
    this.accountId,
    this.accountName,
  });

  final String id;
  final String name;
  final String? parentId;
  final bool isSystem;
  final bool isActive;
  final String? accountId;
  final String? accountName;
}
