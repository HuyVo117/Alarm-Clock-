import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import 'providers/world_clock_providers.dart';
import 'world_clock_card.dart';

/// Màn hình chính của Đồng hồ Thế giới, thiết kế chuẩn iOS Clock.
class WorldClockScreen extends ConsumerStatefulWidget {
  const WorldClockScreen({super.key});

  @override
  ConsumerState<WorldClockScreen> createState() => _WorldClockScreenState();
}

class _WorldClockScreenState extends ConsumerState<WorldClockScreen> {
  bool _isEditing = false;
  Timer? _ticker;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Đồng hồ cập nhật mỗi giây một lần, chỉ rebuild khi widget đang mounted
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final savedCitiesAsync = ref.watch(savedCitiesProvider);
    final service = ref.watch(worldClockServiceProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            setState(() => _isEditing = !_isEditing);
          },
          child: Text(
            _isEditing ? l10n.doneEditing : l10n.editList,
            style: const TextStyle(
              color: AppTheme.accentOrange,
              fontSize: 17,
            ),
          ),
        ),
        middle: Text(l10n.worldClockTitle),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            context.push(AppRoutes.worldClockAdd);
          },
          child: const Icon(
            CupertinoIcons.add,
            color: AppTheme.accentOrange,
            size: 24,
          ),
        ),
      ),
      child: SafeArea(
        child: savedCitiesAsync.when(
          loading: () => const Center(
            child: CupertinoActivityIndicator(),
          ),
          error: (error, stack) => Center(
            child: Text(
              error.toString(),
              style: const TextStyle(color: AppTheme.destructiveRed),
            ),
          ),
          data: (cities) {
            if (cities.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.globe,
                        size: 72,
                        color: AppTheme.labelTertiary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noSavedCities,
                        style: const TextStyle(
                          color: AppTheme.labelPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.noSavedCitiesDesc,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppTheme.labelSecondary,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (_isEditing) {
              return Theme(
                data: ThemeData.dark().copyWith(
                  canvasColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: ReorderableListView.builder(
                  itemCount: cities.length,
                  onReorderItem: (oldIndex, newIndex) {
                    ref
                        .read(savedCitiesProvider.notifier)
                        .reorder(oldIndex, newIndex);
                  },
                  itemBuilder: (context, index) {
                    final city = cities[index];
                    return Container(
                      key: ValueKey(city.id),
                      child: WorldClockCard(
                        city: city,
                        service: service,
                        currentTime: _currentTime,
                        isEditing: true,
                        onDelete: () {
                          ref
                              .read(savedCitiesProvider.notifier)
                              .removeCity(city.id);
                        },
                      ),
                    );
                  },
                ),
              );
            }

            return ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];
                return WorldClockCard(
                  key: ValueKey(city.id),
                  city: city,
                  service: service,
                  currentTime: _currentTime,
                  isEditing: false,
                  onDelete: () {
                    ref.read(savedCitiesProvider.notifier).removeCity(city.id);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
