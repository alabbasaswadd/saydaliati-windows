import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saydaliati/core/theme/app_theme.dart';
import 'package:saydaliati/shared/widgets/buttons/app_button.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// A lightweight smoke test of the shared component library under the app theme.
///
/// It deliberately avoids booting the full app: that pulls in plugin-backed
/// providers (secure storage, connectivity, drift) and entrance-animation timers,
/// which belong in integration tests with those plugins mocked — not a unit smoke
/// test. Widget/feature tests are added per feature as features are built.
void main() {
  Widget host(Widget child) => MaterialApp(
        theme: AppTheme.light,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(body: Center(child: child)),
        ),
      );

  testWidgets('AppButton renders its label and fires onPressed', (tester) async {
    var tapped = false;
    await tester.pumpWidget(host(
      AppButton.primary(
        label: 'حفظ',
        onPressed: () => tapped = true,
        fullWidth: false,
      ),
    ));

    expect(find.text('حفظ'), findsOneWidget);
    await tester.tap(find.byType(AppButton));
    expect(tapped, isTrue);
  });

  testWidgets('EmptyState shows its message', (tester) async {
    await tester.pumpWidget(host(const EmptyState(message: 'لا توجد بيانات')));
    expect(find.text('لا توجد بيانات'), findsOneWidget);
  });
}
