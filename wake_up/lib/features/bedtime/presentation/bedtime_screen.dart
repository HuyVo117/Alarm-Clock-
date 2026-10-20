import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_theme.dart';

class BedtimeScreen extends StatelessWidget {
  const BedtimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.bedtimeTitle),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.moon_fill,
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
