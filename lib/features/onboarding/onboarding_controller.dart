import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/providers/core_providers.dart';

part 'onboarding_controller.g.dart';

/// The guided first-run tour moves through these stages. Each screen shows its
/// own spotlight coach when the current stage matches.
enum OnboardingStage { tabs, medicine, purchase }

class OnboardingState {
  const OnboardingState({this.active = false, this.stage = OnboardingStage.tabs});

  final bool active;
  final OnboardingStage stage;

  OnboardingState copyWith({bool? active, OnboardingStage? stage}) =>
      OnboardingState(active: active ?? this.active, stage: stage ?? this.stage);
}

/// Local flag key marking that the user finished (or skipped) the tour.
const String kOnboardingDoneKey = 'onboarding_done';

/// Drives the interactive first-run tour (tabs → add medicine → add purchase).
/// Screens read [state] to decide whether to show their spotlight, and call the
/// transition methods as the user advances. Completion persists locally so the
/// tour runs only once (re-runnable from Settings).
@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  OnboardingState build() => const OnboardingState();

  /// First-run guided tour is disabled (no explanations on first open). Left as
  /// a no-op so existing callers still work; [restart] can re-enable it manually.
  Future<void> maybeStart() async {
    return;
  }

  /// Advances to [stage] (only while the tour is active).
  void toStage(OnboardingStage stage) {
    if (state.active) state = state.copyWith(stage: stage);
  }

  /// Ends the tour (finished or skipped) and remembers it.
  Future<void> finish() async {
    state = const OnboardingState();
    await ref.read(keyValueStoreProvider).write(kOnboardingDoneKey, 'true');
  }

  /// Re-runs the tour from the beginning (from Settings).
  Future<void> restart() async {
    await ref.read(keyValueStoreProvider).write(kOnboardingDoneKey, 'false');
    state = const OnboardingState(active: true, stage: OnboardingStage.tabs);
  }
}
