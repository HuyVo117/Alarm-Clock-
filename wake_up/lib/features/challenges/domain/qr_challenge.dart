import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'challenge.dart';

/// Thử thách quét QR: phải quét đúng mã QR đã đăng ký lúc cài đặt.
///
/// - Lúc cài đặt: quét QR → lưu SHA-256 hash vào danh sách
/// - Lúc reo: quét QR → tính hash → so khớp
/// - Hỗ trợ nhiều mã QR (chỉ cần khớp 1 trong số đã đăng ký)
///
/// Logic thuần Dart, không phụ thuộc camera plugin.
class QrChallenge implements Challenge {
  /// Danh sách SHA-256 hash của các mã QR đã đăng ký
  final List<String> registeredHashes;

  bool _completed = false;
  String? _lastScannedHash;

  QrChallenge({
    required this.registeredHashes,
  });

  @override
  String get type => 'qr';

  @override
  Map<String, dynamic> get config => {
        'qrHashes': registeredHashes,
      };

  @override
  bool get isCompleted => _completed;

  @override
  double get progress => _completed ? 1.0 : 0.0;

  /// Hash cuối cùng được quét (để UI hiển thị feedback)
  String? get lastScannedHash => _lastScannedHash;

  @override
  Future<void> start() async {
    _completed = false;
    _lastScannedHash = null;
  }

  @override
  Future<bool> verify(dynamic answer) async {
    if (answer is! String || answer.isEmpty) return false;

    _lastScannedHash = hashQrCode(answer);

    if (registeredHashes.contains(_lastScannedHash)) {
      _completed = true;
      return true;
    }
    return false;
  }

  @override
  void reset() {
    _completed = false;
    _lastScannedHash = null;
  }

  @override
  void dispose() {
    // Không có tài nguyên cần giải phóng
  }

  /// Tính SHA-256 hash cho nội dung QR code.
  /// Static để dùng được ở cả setup (khi đăng ký) và verify (khi reo).
  static String hashQrCode(String qrContent) {
    final bytes = utf8.encode(qrContent);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
