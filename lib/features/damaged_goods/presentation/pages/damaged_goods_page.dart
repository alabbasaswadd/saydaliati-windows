import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/features/damaged_goods/presentation/pages/damaged_goods_create_page.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// صفحة البضاعة التالفة — تعرض زرّ تسجيل جديد وتُبلّغ المستخدم أن القائمة
/// ستُضاف لاحقاً. يكفي هذا للنسخة الأولى: التسجيل يعمل والمخزون يُنقَص فعلياً.
class DamagedGoodsPage extends ConsumerWidget {
  const DamagedGoodsPage({super.key});

  Future<void> _openCreate(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const DamagedGoodsCreatePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بضاعة تالفة'),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: SizedBox(
              height: 36,
              child: FilledButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: const Text('تسجيل بضاعة تالفة'),
                onPressed: () => _openCreate(context),
              ),
            ),
          ),
        ],
      ),
      body: const EmptyState(
        message: 'يمكنك تسجيل بضاعة تالفة بالضغط على الزر أعلاه',
        icon: Icons.broken_image_outlined,
      ),
    );
  }
}
