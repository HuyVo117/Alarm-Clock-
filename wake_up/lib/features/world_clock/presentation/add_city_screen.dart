import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../data/city_data.dart';
import 'providers/world_clock_providers.dart';

/// Màn hình tìm kiếm và thêm thành phố vào Đồng hồ Thế giới.
class AddCityScreen extends ConsumerStatefulWidget {
  const AddCityScreen({super.key});

  @override
  ConsumerState<AddCityScreen> createState() => _AddCityScreenState();
}

class _AddCityScreenState extends ConsumerState<AddCityScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Loại bỏ dấu tiếng Việt để tìm kiếm không dấu (ví dụ: "ha noi" -> "Hà Nội")
  String _normalize(String input) {
    var str = input.toLowerCase();
    str = str.replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a');
    str = str.replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e');
    str = str.replaceAll(RegExp(r'[ìíịỉĩ]'), 'i');
    str = str.replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o');
    str = str.replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u');
    str = str.replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y');
    str = str.replaceAll(RegExp(r'[đ]'), 'd');
    return str.trim();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final savedCitiesAsync = ref.watch(savedCitiesProvider);
    final savedCities = savedCitiesAsync.value ?? [];

    final normalizedQuery = _normalize(_searchQuery);

    final filteredCities = CityData.allCities.where((city) {
      if (normalizedQuery.isEmpty) return true;
      final matchCity = _normalize(city.cityName).contains(normalizedQuery);
      final matchCountry = _normalize(city.countryName).contains(normalizedQuery);
      final matchTz = city.timezoneId.toLowerCase().contains(normalizedQuery);
      return matchCity || matchCountry || matchTz;
    }).toList();

    // Sắp xếp theo tên thành phố
    filteredCities.sort((a, b) => a.cityName.compareTo(b.cityName));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.addCity),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => context.pop(),
          child: Text(l10n.cancel),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Ô tìm kiếm phong cách iOS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: l10n.searchCityPlaceholder,
                style: const TextStyle(color: AppTheme.labelPrimary),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),
            ),

            // Danh sách thành phố tìm kiếm
            Expanded(
              child: filteredCities.isEmpty
                  ? Center(
                      child: Text(
                        l10n.noSavedCities,
                        style: const TextStyle(
                          color: AppTheme.labelSecondary,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredCities.length,
                      separatorBuilder: (context, index) => Container(
                        height: 0.5,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        color: AppTheme.separatorColor,
                      ),
                      itemBuilder: (context, index) {
                        final city = filteredCities[index];
                        final isAlreadyAdded = savedCities.any(
                          (c) =>
                              c.id == city.id ||
                              (c.timezoneId == city.timezoneId && c.cityName == city.cityName),
                        );

                        return CupertinoListTile(
                          onTap: isAlreadyAdded
                              ? null
                              : () async {
                                  await ref
                                      .read(savedCitiesProvider.notifier)
                                      .addCity(city);
                                  if (context.mounted) {
                                    context.pop();
                                  }
                                },
                          title: Text(
                            city.cityName,
                            style: TextStyle(
                              color: isAlreadyAdded
                                  ? AppTheme.labelTertiary
                                  : AppTheme.labelPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            '${city.countryName} (${city.timezoneId})',
                            style: TextStyle(
                              color: isAlreadyAdded
                                  ? AppTheme.labelTertiary
                                  : AppTheme.labelSecondary,
                              fontSize: 13,
                            ),
                          ),
                          trailing: isAlreadyAdded
                              ? Text(
                                  l10n.cityAlreadyAdded,
                                  style: const TextStyle(
                                    color: AppTheme.labelTertiary,
                                    fontSize: 13,
                                  ),
                                )
                              : const Icon(
                                  CupertinoIcons.chevron_forward,
                                  color: AppTheme.labelTertiary,
                                  size: 16,
                                ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
