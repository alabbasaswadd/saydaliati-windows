import 'dart:io';

/// سجلّ إقلاعٍ يُكتب في ملف — آخر ما يبقى حين لا تُرى شاشة.
///
/// **لماذا:** تطبيق سطح المكتب بلا نافذة طرفية؛ `print` تذهب إلى العدم، ونافذةٌ
/// سوداء على جهاز عميلٍ بعيد لا تقول شيئاً: أهو المحرّك؟ أم Dart؟ أم أوّل
/// إطار؟ كل سؤالٍ من هذه كان يُكلّف جولةَ مراسلةٍ كاملة مع المستخدم. هذا
/// السجلّ يُجيب عنها كلّها في ملفٍ واحد يُرسَل بنقرة.
///
/// **أين:** `%LOCALAPPDATA%\Saydaliati\startup.log` — من متغيّر البيئة مباشرةً
/// لا عبر `path_provider`: تلك إضافةٌ تحتاج قناة المنصّة، وقد تكون هي نفسها ما
/// يتعطّل، فلا يصحّ أن يعتمد عليها ما يُشخّصها.
///
/// **كل شيء مُغلَّف بـtry/catch**: تشخيصٌ يُسقط التطبيق أسوأ من غياب التشخيص.
abstract final class StartupLog {
  const StartupLog._();

  static File? _file;
  static final Stopwatch _since = Stopwatch()..start();

  /// يفتح السجلّ ويقصّه — فكل تشغيلةٍ تبدأ بصفحةٍ نظيفة ولا ينمو الملف أبداً.
  static void begin(String version) {
    try {
      final base = Platform.environment['LOCALAPPDATA'] ??
          Platform.environment['APPDATA'] ??
          Directory.systemTemp.path;
      final dir = Directory('$base${Platform.pathSeparator}Saydaliati');
      if (!dir.existsSync()) dir.createSync(recursive: true);
      _file = File('${dir.path}${Platform.pathSeparator}startup.log')
        ..writeAsStringSync('');
      write('بدء التشغيل — $version — ${DateTime.now()}');
      write('ويندوز: ${Platform.operatingSystemVersion}');
    } catch (_) {
      _file = null;
    }
  }

  /// سطرٌ مختومٌ بالزمن منذ البدء — فيُعرَف أيُّ مرحلةٍ طالت لا أيُّها وقعت فقط.
  static void write(String message) {
    final f = _file;
    if (f == null) return;
    try {
      f.writeAsStringSync(
        '[${_since.elapsedMilliseconds.toString().padLeft(6)}ms] $message\n',
        mode: FileMode.append,
      );
    } catch (_) {
      // قرصٌ ممتلئ أو مجلّد محميّ — لا شيء يُفعل، ولا شيء يُكسَر.
    }
  }

  static void error(Object error, StackTrace? stack) {
    write('خطأ: $error');
    if (stack != null) {
      // أوّل خمسة أسطر تكفي لتحديد الموضع، والباقي ضجيج في ملفٍ يُقرأ بالعين.
      final lines = stack.toString().split('\n').take(5);
      for (final line in lines) {
        write('    $line');
      }
    }
  }
}
