import 'package:flutter/widgets.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/errors/failure.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';

/// Surfaces a [Failure] (or any error object) as an error snackbar, using the
/// failure's localized [Failure.displayMessage] — which carries the backend's
/// message when present.
///
/// Use after an action whose controller returns a bool and stores the failure in
/// its `AsyncValue` state: on failure, pass `ref.read(<controller>Provider).error`
/// here so the message actually reaches the user instead of being swallowed.
void showFailureSnackbar(BuildContext context, Object? error) {
  AppSnackbar.error(
    context,
    error is Failure ? error.displayMessage : AppStrings.errorDefault,
  );
}
