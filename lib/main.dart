import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saydaliati/app/app.dart';
import 'package:saydaliati/app/di/app_bootstrap.dart';
import 'package:saydaliati/core/diagnostics/startup_log.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';

/// نقطة البدء.
///
/// كل مرحلةٍ تُسجَّل في [StartupLog]: نافذةٌ سوداء على جهاز عميلٍ بعيد لا تقول
/// أين وقف التطبيق، والسجلّ يقولها في سطر. وكل خطأٍ غير ملتقَط — في الإقلاع أو
/// في أيّ إطارٍ بعده — يُكتب فيه أيضاً بدل أن يذهب إلى العدم.
void main() async {
  StartupLog.begin('1.2.0+15');

  // أخطاء الإطار (build/layout/paint) — تصل هنا بدل أن تُطبع في العدم.
  final previousOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    StartupLog.error(details.exception, details.stack);
    previousOnError?.call(details);
  };

  // أخطاء غير متزامنة خارج الإطار (مستقبلات معلّقة، قنوات منصّة…).
  PlatformDispatcher.instance.onError = (error, stack) {
    StartupLog.error(error, stack);
    return false;
  };

  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    StartupLog.write('تهيئة فلاتر: تمّت');

    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      await windowManager.ensureInitialized();
      StartupLog.write('تهيئة مدير النوافذ: تمّت');

      // المقاس يتبع الشاشة لا رقماً ثابتاً.
      //
      // كان الحدّ الأدنى 1280×720 **منطقياً**، وهو أكبر من شاشة لابتوب
      // 1366×768 عند تكبير 125% (المتاح حينها 1092×614 فقط) — فتُطلَب نافذةٌ
      // لا تتّسع لها الشاشة. ولا رسالة تُنبّه، بل نافذةٌ تتصرّف تصرّفاً غير
      // محدَّد. والمقاس الآن يُقصّ إلى ما تسمح به الشاشة فعلاً، ويبقى
      // الافتراضيّ المريح حين تتّسع.
      final display = await screenRetriever.getPrimaryDisplay();
      final screen = display.visibleSize ?? display.size;
      StartupLog.write('الشاشة: ${screen.width.toInt()}×${screen.height.toInt()}'
          ' | التكبير: ${display.scaleFactor ?? 1}');

      // هامشٌ بسيط فلا تلتصق النافذة بالحافة.
      final width = math.min(1366.0, screen.width - 40);
      final height = math.min(768.0, screen.height - 60);

      // مخرجُ نجاةٍ من شريط العنوان المخصَّص.
      //
      // إخفاء إطار النظام (`TitleBarStyle.hidden`) يجعل النافذة تُدار بإطارٍ
      // من صنعنا. وعلى بعض أجهزة ويندوز 10 يُرسَم الإطار ولا يُعرَض —
      // فتبقى النافذة سوداء بلا خطأٍ ولا استثناء، وهو أسوأ أنواع الأعطال:
      // لا شيء يدلّ عليه.
      //
      // فمتى وُجد المتغيّر `SAYDALIATI_NATIVE_TITLEBAR` عاد إطار النظام
      // المعتاد. التطبيق يصير بشريطَي عنوان — شكلٌ أقلّ أناقة، لكنه **يُرى**،
      // وهذا وحده يفصل العطل عن غيره ويُعطي المستخدم مخرجاً فورياً بدل
      // انتظار بناءٍ جديد.
      final nativeTitleBar =
          Platform.environment['SAYDALIATI_NATIVE_TITLEBAR'] != null;
      StartupLog.write('شريط العنوان: ${nativeTitleBar ? "نظام" : "مخصَّص"}'
          ' | محرّك الرسم: '
          '${Platform.environment['SAYDALIATI_IMPELLER'] == '1' ? "Impeller" : "Skia"}');

      final options = WindowOptions(
        size: Size(width, height),
        // الأدنى لا يتجاوز المتاح أبداً.
        minimumSize: Size(math.min(1024.0, width), math.min(640.0, height)),
        center: true,
        skipTaskbar: false,
        titleBarStyle:
            nativeTitleBar ? TitleBarStyle.normal : TitleBarStyle.hidden,
      );
      StartupLog.write('المقاس المطلوب: ${width.toInt()}×${height.toInt()}');

      await windowManager.waitUntilReadyToShow(options, () async {
        await windowManager.show();
        await windowManager.focus();
      });

      final bounds = await windowManager.getBounds();
      StartupLog.write('إظهار النافذة: تمّ — الفعليّ:'
          ' ${bounds.width.toInt()}×${bounds.height.toInt()}'
          ' عند (${bounds.left.toInt()},${bounds.top.toInt()})');
    }

    // أوّل إطارٍ مرسوم: وجودُ هذا السطر يفصل «لا يرسم» عن «يرسم ولا يُرى».
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StartupLog.write('أوّل إطار: رُسم');
    });

    StartupLog.write('تشغيل التطبيق…');
    runApp(AppBootstrap.wrap(const SaydaliatiApp()));
  }, (error, stack) {
    StartupLog.error(error, stack);
  });
}
