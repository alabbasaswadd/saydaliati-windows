import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/roles/domain/entities/permission_item.dart';

abstract interface class PermissionRepository {
  /// الكتالوج الكامل (غير مُجمَّع) — التجميع حسب `module` يحدث في الواجهة.
  Future<Result<List<PermissionItem>>> getAll();
}
