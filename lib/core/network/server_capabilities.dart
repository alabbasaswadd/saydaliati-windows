import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';
import 'package:saydaliati/core/providers/core_providers.dart';

/// هل يفهم الخادم المنشور إرسالَ المبالغ بعملتها الأصلية؟
///
/// **لماذا هذا موجود:** الواجهة صارت ترسل لفاتورة بـ١٠٠ دولار الرقمَ `100`
/// معتمدةً على أن الخادم يحوّله. وخادم أقدم يتجاهل العلم ويأخذ `100` على أنها
/// بالعملة الأساسية — فتُسجَّل الفاتورة **١٠٠ ليرة بدل ١٤٬١٠٠**، خسارة صامتة
/// بمقدار سعر الصرف كلّه.
///
/// الاعتماد على «انشر الخادم أولاً» ضمانةٌ بشرية لا هندسية: نسخة قديمة بقيت
/// على جهاز، أو نشر فشل جزئياً، يكفيان لإفساد فواتير يوم كامل بلا إنذار.
/// لذا تسأل الواجهة الخادم عن قدرته، ولا ترسل بالعملة الأصلية إلا إن أكّدها.
///
/// **الافتراض عند الشك هو السلوك القديم** (التحويل على العميل): غير دقيق عند
/// تباعد الأسعار، لكنه لا يُفسد شيئاً — بخلاف العكس.
class ServerCapabilities {
  const ServerCapabilities({required this.amountsInOriginalCurrency});

  /// `false` = حوِّل على العميل كما كان.
  final bool amountsInOriginalCurrency;

  static const ServerCapabilities legacy =
      ServerCapabilities(amountsInOriginalCurrency: false);
}

/// يُقرأ مرّة عند الحاجة ويُحتفظ به؛ تغيّر قدرات الخادم يستلزم إعادة تشغيل
/// التطبيق على أي حال (نشر جديد).
final serverCapabilitiesProvider =
    FutureProvider<ServerCapabilities>((ref) async {
  final api = ref.watch(apiClientProvider);
  try {
    final data = await api.get(ApiEndpoints.capabilities);
    if (data is! Map) return ServerCapabilities.legacy;
    return ServerCapabilities(
      amountsInOriginalCurrency:
          data['amountsInOriginalCurrency'] == true,
    );
  } catch (_) {
    // نقطة غير موجودة (خادم أقدم) أو تعذّر الوصول ⇒ السلوك الآمن.
    return ServerCapabilities.legacy;
  }
});

/// قراءة متزامنة للقدرات — ما لم تصل بعد فالسلوك القديم.
extension ServerCapabilitiesX on WidgetRef {
  ServerCapabilities get serverCapabilities =>
      watch(serverCapabilitiesProvider).value ?? ServerCapabilities.legacy;
}
