import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';
import 'package:saydaliati/core/providers/core_providers.dart';

part 'auth_providers.g.dart';

/// Thin client for the auth endpoints. Returns the unwrapped `data` map
/// ({token, userId, tenantId, pharmacyName, userName}).
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> register({
    required String pharmacyName,
    required String email,
    required String phone,
    required String userName,
    required String password,
    required String governorate,
    String city = '',
    String address = '',
    double usdExchangeRate = 0,
  }) async {
    // العملة الأساسية ثابتة (ليرة سورية) وتُبذر في الخادم؛ نرسل سعر صرف الدولار
    // مقابل الليرة (كم ل.س يساوي 1$) لضبط عملة الدولار الثانوية.
    final data = await _api.post(ApiEndpoints.authRegister, data: {
      'pharmacyName': pharmacyName,
      'email': email,
      'phone': phone,
      'userName': userName,
      'password': password,
      'governorate': governorate,
      'city': city,
      'address': address,
      'usdExchangeRate': usdExchangeRate,
    });
    return (data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> me() async {
    final data = await _api.get(ApiEndpoints.authMe);
    return (data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> login({
    required String login,
    required String password,
  }) async {
    final data = await _api.post(ApiEndpoints.authLogin, data: {
      'login': login,
      'password': password,
    });
    return (data as Map).cast<String, dynamic>();
  }
}

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) =>
    AuthRemoteDataSource(ref.watch(apiClientProvider));

/// بيانات المستخدم والصيدلية الحالية.
///
/// مزوّد لا `FutureBuilder` في `initState`: الأوّل قابل للتحديث
/// (`ref.invalidate`) ومشترك بين الشاشات، والثاني يُعيد النداء مع كل إعادة
/// بناء للحالة ولا سبيل لتحديثه دون `setState`.
///
/// `keepAlive`: يُقرَأ من عدّة أماكن متزامنة (الشريط الجانبي لكل عنصر
/// صلاحية، مُستمِع إعادة توجيه الراوتر، شاشة الحساب...)، فبلا `keepAlive`
/// كان يُهدَم ويُعاد بناؤه بتسارع مع كل تبديل مستمعين — وتحت ذلك التزامن
/// رصد Riverpod المزوّد يعتمد على نفسه (`CircularDependencyError`)، فتفشل
/// كل العمليات التي يعبر طلبها نفس سلسلة الاعتراض (حتى طلبات لا علاقة لها
/// بالصلاحيات، كحفظ مصروف) وتختفي عناصر الشريط المقيّدة بصلاحية لأن
/// [currentUserPermissionsProvider] يرتدّ لصلاحيات فارغة عند فشل القراءة.
@Riverpod(keepAlive: true)
Future<Map<String, dynamic>> currentUser(Ref ref) =>
    ref.watch(authRemoteDataSourceProvider).me();
