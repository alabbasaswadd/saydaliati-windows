import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_constants.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Whether the first-run intro carousel has already been seen (persisted).
///
/// Read from SharedPreferences (fast) so the startup gate never waits on the
/// Keystore-backed secure storage. Migrates the flag from secure storage once
/// for users upgrading from an older build.
final introSeenProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final cached = prefs.getBool(AppConstants.introSeenKey);
  if (cached != null) return cached;

  // One-time migration from the old secure-storage location.
  final legacy =
      await ref.read(keyValueStoreProvider).read(AppConstants.introSeenKey);
  final seen = legacy == 'true';
  await prefs.setBool(AppConstants.introSeenKey, seen);
  return seen;
});

/// Marks the intro as seen and refreshes the gate.
Future<void> markIntroSeen(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(AppConstants.introSeenKey, true);
  ref.invalidate(introSeenProvider);
}
