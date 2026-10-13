// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the interactive first-run tour (tabs → add medicine → add purchase).
/// Screens read [state] to decide whether to show their spotlight, and call the
/// transition methods as the user advances. Completion persists locally so the
/// tour runs only once (re-runnable from Settings).

@ProviderFor(OnboardingController)
final onboardingControllerProvider = OnboardingControllerProvider._();

/// Drives the interactive first-run tour (tabs → add medicine → add purchase).
/// Screens read [state] to decide whether to show their spotlight, and call the
/// transition methods as the user advances. Completion persists locally so the
/// tour runs only once (re-runnable from Settings).
final class OnboardingControllerProvider
    extends $NotifierProvider<OnboardingController, OnboardingState> {
  /// Drives the interactive first-run tour (tabs → add medicine → add purchase).
  /// Screens read [state] to decide whether to show their spotlight, and call the
  /// transition methods as the user advances. Completion persists locally so the
  /// tour runs only once (re-runnable from Settings).
  OnboardingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingControllerHash();

  @$internal
  @override
  OnboardingController create() => OnboardingController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingState>(value),
    );
  }
}

String _$onboardingControllerHash() =>
    r'8e3a0134896bc583cb36c1b86b3b5c99403427d6';

/// Drives the interactive first-run tour (tabs → add medicine → add purchase).
/// Screens read [state] to decide whether to show their spotlight, and call the
/// transition methods as the user advances. Completion persists locally so the
/// tour runs only once (re-runnable from Settings).

abstract class _$OnboardingController extends $Notifier<OnboardingState> {
  OnboardingState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<OnboardingState, OnboardingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OnboardingState, OnboardingState>,
              OnboardingState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
