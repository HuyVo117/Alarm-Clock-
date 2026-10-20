import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';

/// Màn hình placeholder cho các tab chưa triển khai.
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppTheme.labelTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.comingSoon,
              style: const TextStyle(
                color: AppTheme.labelSecondary,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
