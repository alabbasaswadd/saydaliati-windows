import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

/// "About us" screen: brief intro, CodeTech partnership, and official links.
///
/// The links below are placeholders — edit them when the real accounts are
/// ready (Telegram/Facebook are dummy handles for now).
const String _kOfficialSite = 'https://codetechsyria.com/saydaliati/';
const String _kTelegram = 'https://t.me/saydaliati';
const String _kFacebook = 'https://facebook.com/saydaliati';
const String _kAppVersion = '1.0.0';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _open(BuildContext context, String url) async {
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      AppSnackbar.error(context, AppStrings.linkOpenFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.aboutApp)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // App identity
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.local_pharmacy_outlined,
                      size: 44, color: theme.colorScheme.primary),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(AppStrings.appName,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text('${AppStrings.versionLabel} $_kAppVersion',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.hintColor)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Who we are
          _card(
            theme,
            title: AppStrings.aboutWhoTitle,
            child: Text(AppStrings.aboutBody,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.7)),
          ),
          const SizedBox(height: AppSpacing.md),

          // Partnership
          _card(
            theme,
            title: AppStrings.aboutPartnerWith,
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('CT',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w900)),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CodeTech',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text(AppStrings.aboutPartnerBody,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.hintColor, height: 1.6)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Follow us
          Text(AppStrings.aboutFollowUs,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Column(
              children: [
                _linkTile(context, Icons.language_outlined,
                    AppStrings.officialSite, _kOfficialSite),
                const Divider(height: 1),
                _linkTile(context, Icons.send_outlined,
                    AppStrings.telegramLabel, _kTelegram),
                const Divider(height: 1),
                _linkTile(context, Icons.facebook_outlined,
                    AppStrings.facebookLabel, _kFacebook),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(ThemeData theme, {required String title, required Widget child}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: AppSpacing.sm),
            child,
          ],
        ),
      ),
    );
  }

  Widget _linkTile(
      BuildContext context, IconData icon, String label, String url) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(url,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall),
      trailing: const Icon(Icons.open_in_new, size: 18),
      onTap: () => _open(context, url),
    );
  }
}
