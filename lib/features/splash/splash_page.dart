import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';

/// Shown while the persisted session is being restored on startup, so the login
/// screen never flashes before the router knows whether the user is signed in.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_pharmacy,
                size: 72, color: theme.colorScheme.onPrimary),
            const SizedBox(height: 16),
            Text(
              AppStrings.appName,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor:
                    AlwaysStoppedAnimation(theme.colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
