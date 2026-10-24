import 'package:flutter/material.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

/// يحوّل رقماً محلياً سورياً (`0988693463`) إلى صيغة دولية (`963988693463`)
/// لبناء رابط `wa.me` — واتساب لا يقبل الصفر المحلي بالرابط.
String _toInternational(String localNumber) =>
    localNumber.startsWith('0') ? '963${localNumber.substring(1)}' : localNumber;

/// صيغة عرض مقروءة: `+963 988 693 463`.
String formatWhatsAppNumber(String localNumber) {
  final intl = _toInternational(localNumber);
  return '+$intl';
}

/// يفتح محادثة واتساب مع [localNumber] بالتطبيق الخارجي أو المتصفح.
Future<void> openWhatsApp(BuildContext context, String localNumber) async {
  final uri = Uri.parse('https://wa.me/${_toInternational(localNumber)}');
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) {
    AppSnackbar.error(context, 'تعذّر فتح واتساب');
  }
}
