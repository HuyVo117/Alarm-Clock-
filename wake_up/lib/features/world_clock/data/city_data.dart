import '../domain/world_city_model.dart';

/// Danh sách tĩnh các thành phố phổ biến trên toàn thế giới và Việt Nam.
/// Sử dụng trực tiếp mã IANA timezone chuẩn.
class CityData {
  static const List<WorldCityModel> allCities = [
    // --- VIỆT NAM ---
    WorldCityModel(
      id: 'city_hanoi',
      timezoneId: 'Asia/Ho_Chi_Minh',
      cityName: 'Hà Nội',
      countryName: 'Việt Nam',
    ),
    WorldCityModel(
      id: 'city_hcm',
      timezoneId: 'Asia/Ho_Chi_Minh',
      cityName: 'TP. Hồ Chí Minh',
      countryName: 'Việt Nam',
    ),
    WorldCityModel(
      id: 'city_danang',
      timezoneId: 'Asia/Ho_Chi_Minh',
      cityName: 'Đà Nẵng',
      countryName: 'Việt Nam',
    ),
    WorldCityModel(
      id: 'city_haiphong',
      timezoneId: 'Asia/Ho_Chi_Minh',
      cityName: 'Hải Phòng',
      countryName: 'Việt Nam',
    ),
    WorldCityModel(
      id: 'city_cantho',
      timezoneId: 'Asia/Ho_Chi_Minh',
      cityName: 'Cần Thơ',
      countryName: 'Việt Nam',
    ),
    WorldCityModel(
      id: 'city_hue',
      timezoneId: 'Asia/Ho_Chi_Minh',
      cityName: 'Huế',
      countryName: 'Việt Nam',
    ),
    WorldCityModel(
      id: 'city_nhatrang',
      timezoneId: 'Asia/Ho_Chi_Minh',
      cityName: 'Nha Trang',
      countryName: 'Việt Nam',
    ),

    // --- CHÂU Á ---
    WorldCityModel(
      id: 'city_tokyo',
      timezoneId: 'Asia/Tokyo',
      cityName: 'Tokyo',
      countryName: 'Nhật Bản',
    ),
    WorldCityModel(
      id: 'city_seoul',
      timezoneId: 'Asia/Seoul',
      cityName: 'Seoul',
      countryName: 'Hàn Quốc',
    ),
    WorldCityModel(
      id: 'city_beijing',
      timezoneId: 'Asia/Shanghai',
      cityName: 'Bắc Kinh',
      countryName: 'Trung Quốc',
    ),
    WorldCityModel(
      id: 'city_shanghai',
      timezoneId: 'Asia/Shanghai',
      cityName: 'Thượng Hải',
      countryName: 'Trung Quốc',
    ),
    WorldCityModel(
      id: 'city_hongkong',
      timezoneId: 'Asia/Hong_Kong',
      cityName: 'Hồng Kông',
      countryName: 'Hồng Kông',
    ),
    WorldCityModel(
      id: 'city_taipei',
      timezoneId: 'Asia/Taipei',
      cityName: 'Đài Bắc',
      countryName: 'Đài Loan',
    ),
    WorldCityModel(
      id: 'city_bangkok',
      timezoneId: 'Asia/Bangkok',
      cityName: 'Bangkok',
      countryName: 'Thái Lan',
    ),
    WorldCityModel(
      id: 'city_singapore',
      timezoneId: 'Asia/Singapore',
      cityName: 'Singapore',
      countryName: 'Singapore',
    ),
    WorldCityModel(
      id: 'city_kualalumpur',
      timezoneId: 'Asia/Kuala_Lumpur',
      cityName: 'Kuala Lumpur',
      countryName: 'Malaysia',
    ),
    WorldCityModel(
      id: 'city_jakarta',
      timezoneId: 'Asia/Jakarta',
      cityName: 'Jakarta',
      countryName: 'Indonesia',
    ),
    WorldCityModel(
      id: 'city_manila',
      timezoneId: 'Asia/Manila',
      cityName: 'Manila',
      countryName: 'Philippines',
    ),
    WorldCityModel(
      id: 'city_phnompenh',
      timezoneId: 'Asia/Phnom_Penh',
      cityName: 'Phnôm Pênh',
      countryName: 'Campuchia',
    ),
    WorldCityModel(
      id: 'city_vientiane',
      timezoneId: 'Asia/Vientiane',
      cityName: 'Viêng Chăn',
      countryName: 'Lào',
    ),
    WorldCityModel(
      id: 'city_yangon',
      timezoneId: 'Asia/Yangon',
      cityName: 'Yangon',
      countryName: 'Myanmar',
    ),
    WorldCityModel(
      id: 'city_newdelhi',
      timezoneId: 'Asia/Kolkata',
      cityName: 'New Delhi',
      countryName: 'Ấn Độ',
    ),
    WorldCityModel(
      id: 'city_mumbai',
      timezoneId: 'Asia/Kolkata',
      cityName: 'Mumbai',
      countryName: 'Ấn Độ',
    ),
    WorldCityModel(
      id: 'city_dubai',
      timezoneId: 'Asia/Dubai',
      cityName: 'Dubai',
      countryName: 'Các TVQ Arab Thống nhất',
    ),
    WorldCityModel(
      id: 'city_doha',
      timezoneId: 'Asia/Qatar',
      cityName: 'Doha',
      countryName: 'Qatar',
    ),
    WorldCityModel(
      id: 'city_riyadh',
      timezoneId: 'Asia/Riyadh',
      cityName: 'Riyadh',
      countryName: 'Ả Rập Xê Út',
    ),
    WorldCityModel(
      id: 'city_telaviv',
      timezoneId: 'Asia/Jerusalem',
      cityName: 'Tel Aviv',
      countryName: 'Israel',
    ),
    WorldCityModel(
      id: 'city_istanbul',
      timezoneId: 'Europe/Istanbul',
      cityName: 'Istanbul',
      countryName: 'Thổ Nhĩ Kỳ',
    ),
    WorldCityModel(
      id: 'city_tashkent',
      timezoneId: 'Asia/Tashkent',
      cityName: 'Tashkent',
      countryName: 'Uzbekistan',
    ),
    WorldCityModel(
      id: 'city_almaty',
      timezoneId: 'Asia/Almaty',
      cityName: 'Almaty',
      countryName: 'Kazakhstan',
    ),

    // --- CHÂU ÂU ---
    WorldCityModel(
      id: 'city_london',
      timezoneId: 'Europe/London',
      cityName: 'London',
      countryName: 'Vương quốc Anh',
    ),
    WorldCityModel(
      id: 'city_paris',
      timezoneId: 'Europe/Paris',
      cityName: 'Paris',
      countryName: 'Pháp',
    ),
    WorldCityModel(
      id: 'city_berlin',
      timezoneId: 'Europe/Berlin',
      cityName: 'Berlin',
      countryName: 'Đức',
    ),
    WorldCityModel(
      id: 'city_rome',
      timezoneId: 'Europe/Rome',
      cityName: 'Rome',
      countryName: 'Ý',
    ),
    WorldCityModel(
      id: 'city_madrid',
      timezoneId: 'Europe/Madrid',
      cityName: 'Madrid',
      countryName: 'Tây Ban Nha',
    ),
    WorldCityModel(
      id: 'city_amsterdam',
      timezoneId: 'Europe/Amsterdam',
      cityName: 'Amsterdam',
      countryName: 'Hà Lan',
    ),
    WorldCityModel(
      id: 'city_brussels',
      timezoneId: 'Europe/Brussels',
      cityName: 'Brussels',
      countryName: 'Bỉ',
    ),
    WorldCityModel(
      id: 'city_vienna',
      timezoneId: 'Europe/Vienna',
      cityName: 'Vienna',
      countryName: 'Áo',
    ),
    WorldCityModel(
      id: 'city_zurich',
      timezoneId: 'Europe/Zurich',
      cityName: 'Zurich',
      countryName: 'Thụy Sĩ',
    ),
    WorldCityModel(
      id: 'city_geneva',
      timezoneId: 'Europe/Zurich',
      cityName: 'Geneva',
      countryName: 'Thụy Sĩ',
    ),
    WorldCityModel(
      id: 'city_stockholm',
      timezoneId: 'Europe/Stockholm',
      cityName: 'Stockholm',
      countryName: 'Thụy Điển',
    ),
    WorldCityModel(
      id: 'city_oslo',
      timezoneId: 'Europe/Oslo',
      cityName: 'Oslo',
      countryName: 'Na Uy',
    ),
    WorldCityModel(
      id: 'city_copenhagen',
      timezoneId: 'Europe/Copenhagen',
      cityName: 'Copenhagen',
      countryName: 'Đan Mạch',
    ),
    WorldCityModel(
      id: 'city_helsinki',
      timezoneId: 'Europe/Helsinki',
      cityName: 'Helsinki',
      countryName: 'Phần Lan',
    ),
    WorldCityModel(
      id: 'city_athens',
      timezoneId: 'Europe/Athens',
      cityName: 'Athens',
      countryName: 'Hy Lạp',
    ),
    WorldCityModel(
      id: 'city_prague',
      timezoneId: 'Europe/Prague',
      cityName: 'Prague',
      countryName: 'Cộng hòa Séc',
    ),
    WorldCityModel(
      id: 'city_warsaw',
      timezoneId: 'Europe/Warsaw',
      cityName: 'Warsaw',
      countryName: 'Ba Lan',
    ),
    WorldCityModel(
      id: 'city_budapest',
      timezoneId: 'Europe/Budapest',
      cityName: 'Budapest',
      countryName: 'Hungary',
    ),
    WorldCityModel(
      id: 'city_dublin',
      timezoneId: 'Europe/Dublin',
      cityName: 'Dublin',
      countryName: 'Ireland',
    ),
    WorldCityModel(
      id: 'city_lisbon',
      timezoneId: 'Europe/Lisbon',
      cityName: 'Lisbon',
      countryName: 'Bồ Đào Nha',
    ),
    WorldCityModel(
      id: 'city_moscow',
      timezoneId: 'Europe/Moscow',
      cityName: 'Moscow',
      countryName: 'Nga',
    ),
    WorldCityModel(
      id: 'city_kyiv',
      timezoneId: 'Europe/Kyiv',
      cityName: 'Kyiv',
      countryName: 'Ukraine',
    ),

    // --- CHÂU MỸ ---
    WorldCityModel(
      id: 'city_newyork',
      timezoneId: 'America/New_York',
      cityName: 'New York',
      countryName: 'Hoa Kỳ',
    ),
    WorldCityModel(
      id: 'city_losangeles',
      timezoneId: 'America/Los_Angeles',
      cityName: 'Los Angeles',
      countryName: 'Hoa Kỳ',
    ),
    WorldCityModel(
      id: 'city_chicago',
      timezoneId: 'America/Chicago',
      cityName: 'Chicago',
      countryName: 'Hoa Kỳ',
    ),
    WorldCityModel(
      id: 'city_sanfrancisco',
      timezoneId: 'America/Los_Angeles',
      cityName: 'San Francisco',
      countryName: 'Hoa Kỳ',
    ),
    WorldCityModel(
      id: 'city_washington',
      timezoneId: 'America/New_York',
      cityName: 'Washington, D.C.',
      countryName: 'Hoa Kỳ',
    ),
    WorldCityModel(
      id: 'city_miami',
      timezoneId: 'America/New_York',
      cityName: 'Miami',
      countryName: 'Hoa Kỳ',
    ),
    WorldCityModel(
      id: 'city_seattle',
      timezoneId: 'America/Los_Angeles',
      cityName: 'Seattle',
      countryName: 'Hoa Kỳ',
    ),
    WorldCityModel(
      id: 'city_toronto',
      timezoneId: 'America/Toronto',
      cityName: 'Toronto',
      countryName: 'Canada',
    ),
    WorldCityModel(
      id: 'city_vancouver',
      timezoneId: 'America/Vancouver',
      cityName: 'Vancouver',
      countryName: 'Canada',
    ),
    WorldCityModel(
      id: 'city_mexicocity',
      timezoneId: 'America/Mexico_City',
      cityName: 'Mexico City',
      countryName: 'Mexico',
    ),
    WorldCityModel(
      id: 'city_saopaulo',
      timezoneId: 'America/Sao_Paulo',
      cityName: 'São Paulo',
      countryName: 'Brazil',
    ),
    WorldCityModel(
      id: 'city_riodejaneiro',
      timezoneId: 'America/Sao_Paulo',
      cityName: 'Rio de Janeiro',
      countryName: 'Brazil',
    ),
    WorldCityModel(
      id: 'city_buenosaires',
      timezoneId: 'America/Argentina/Buenos_Aires',
      cityName: 'Buenos Aires',
      countryName: 'Argentina',
    ),
    WorldCityModel(
      id: 'city_santiago',
      timezoneId: 'America/Santiago',
      cityName: 'Santiago',
      countryName: 'Chile',
    ),
    WorldCityModel(
      id: 'city_bogota',
      timezoneId: 'America/Bogota',
      cityName: 'Bogotá',
      countryName: 'Colombia',
    ),
    WorldCityModel(
      id: 'city_havana',
      timezoneId: 'America/Havana',
      cityName: 'Havana',
      countryName: 'Cuba',
    ),
    WorldCityModel(
      id: 'city_honolulu',
      timezoneId: 'Pacific/Honolulu',
      cityName: 'Honolulu',
      countryName: 'Hoa Kỳ (Hawaii)',
    ),

    // --- CHÂU ÚC & THÁI BÌNH DƯƠNG ---
    WorldCityModel(
      id: 'city_sydney',
      timezoneId: 'Australia/Sydney',
      cityName: 'Sydney',
      countryName: 'Úc',
    ),
    WorldCityModel(
      id: 'city_melbourne',
      timezoneId: 'Australia/Melbourne',
      cityName: 'Melbourne',
      countryName: 'Úc',
    ),
    WorldCityModel(
      id: 'city_brisbane',
      timezoneId: 'Australia/Brisbane',
      cityName: 'Brisbane',
      countryName: 'Úc',
    ),
    WorldCityModel(
      id: 'city_perth',
      timezoneId: 'Australia/Perth',
      cityName: 'Perth',
      countryName: 'Úc',
    ),
    WorldCityModel(
      id: 'city_auckland',
      timezoneId: 'Pacific/Auckland',
      cityName: 'Auckland',
      countryName: 'New Zealand',
    ),
    WorldCityModel(
      id: 'city_wellington',
      timezoneId: 'Pacific/Auckland',
      cityName: 'Wellington',
      countryName: 'New Zealand',
    ),

    // --- CHÂU PHI ---
    WorldCityModel(
      id: 'city_cairo',
      timezoneId: 'Africa/Cairo',
      cityName: 'Cairo',
      countryName: 'Ai Cập',
    ),
    WorldCityModel(
      id: 'city_johannesburg',
      timezoneId: 'Africa/Johannesburg',
      cityName: 'Johannesburg',
      countryName: 'Nam Phi',
    ),
    WorldCityModel(
      id: 'city_capetown',
      timezoneId: 'Africa/Johannesburg',
      cityName: 'Cape Town',
      countryName: 'Nam Phi',
    ),
    WorldCityModel(
      id: 'city_nairobi',
      timezoneId: 'Africa/Nairobi',
      cityName: 'Nairobi',
      countryName: 'Kenya',
    ),
    WorldCityModel(
      id: 'city_casablanca',
      timezoneId: 'Africa/Casablanca',
      cityName: 'Casablanca',
      countryName: 'Ma-rốc',
    ),
  ];

  /// Các thành phố mặc định hiển thị khi người dùng mở ứng dụng lần đầu.
  static const List<WorldCityModel> defaultCities = [
    WorldCityModel(
      id: 'city_hanoi',
      timezoneId: 'Asia/Ho_Chi_Minh',
      cityName: 'Hà Nội',
      countryName: 'Việt Nam',
      sortOrder: 0,
    ),
    WorldCityModel(
      id: 'city_tokyo',
      timezoneId: 'Asia/Tokyo',
      cityName: 'Tokyo',
      countryName: 'Nhật Bản',
      sortOrder: 1,
    ),
    WorldCityModel(
      id: 'city_london',
      timezoneId: 'Europe/London',
      cityName: 'London',
      countryName: 'Vương quốc Anh',
      sortOrder: 2,
    ),
    WorldCityModel(
      id: 'city_newyork',
      timezoneId: 'America/New_York',
      cityName: 'New York',
      countryName: 'Hoa Kỳ',
      sortOrder: 3,
    ),
  ];
}
