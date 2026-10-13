/// Reads a backend `ApiResult<T>` envelope **case-insensitively**.
///
/// Many APIs serialize success responses in camelCase (`succeeded`/`data`/
/// `errors`) and error responses in PascalCase (`Succeeded`/`Data`/`Errors`). A
/// robust client must not care which — so this reader looks each key up in a
/// case-insensitive way. Adapt the expected keys to your backend's contract.
class ApiEnvelope {
  const ApiEnvelope({
    required this.succeeded,
    required this.data,
    required this.errors,
  });

  final bool succeeded;
  final Object? data;

  /// `{ [key]: string[] }` — keyed by field name (400) or business code (422).
  final Map<String, List<String>> errors;

  /// Parses [body] (a decoded JSON map) into an envelope. If [body] is not a map
  /// (e.g. a framework 401 with an empty body), returns a "failed, empty" envelope.
  factory ApiEnvelope.from(Object? body) {
    if (body is! Map) {
      return const ApiEnvelope(
        succeeded: false,
        data: null,
        errors: <String, List<String>>{},
      );
    }

    final normalized = <String, Object?>{};
    body.forEach((key, value) => normalized[key.toString().toLowerCase()] = value);

    return ApiEnvelope(
      succeeded: (normalized['succeeded'] as bool?) ?? false,
      data: normalized['data'],
      errors: _parseErrors(normalized['errors']).isNotEmpty
          ? _parseErrors(normalized['errors'])
          : _flatMessageErrors(normalized),
    );
  }

  /// Fallback for error bodies that carry a flat `message` (optionally a `code`)
  /// instead of the standard `errors` map. Yields `{ code: [message] }` so
  /// [firstError] (and the UI) can still surface the server's message.
  static Map<String, List<String>> _flatMessageErrors(Map<String, Object?> normalized) {
    final message = normalized['message'];
    if (message is! String || message.isEmpty) return const <String, List<String>>{};
    final code = (normalized['code'] as String?)?.trim();
    return <String, List<String>>{
      (code == null || code.isEmpty) ? 'error' : code: <String>[message],
    };
  }

  /// The first error `[key, message]`, or null.
  ({String key, String message})? get firstError {
    for (final entry in errors.entries) {
      if (entry.value.isNotEmpty) {
        return (key: entry.key, message: entry.value.first);
      }
    }
    return null;
  }

  static Map<String, List<String>> _parseErrors(Object? raw) {
    if (raw is! Map) return const <String, List<String>>{};
    final result = <String, List<String>>{};
    raw.forEach((key, value) {
      result[key.toString()] = switch (value) {
        final List<dynamic> list => list.map((e) => e.toString()).toList(),
        final String s => <String>[s],
        null => <String>[],
        _ => <String>[value.toString()],
      };
    });
    return result;
  }
}
