import 'package:flutter/cupertino.dart';
import 'package:wake_up/core/l10n/app_localizations.dart';

import '../../../core/theme/app_theme.dart';

class GardenScreen extends StatelessWidget {
  const GardenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.gardenTitle),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.tree,
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
