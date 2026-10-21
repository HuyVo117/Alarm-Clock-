import 'challenge.dart';
import 'challenge_config.dart';
import 'math_challenge.dart';
import 'shake_challenge.dart';
import 'qr_challenge.dart';
import 'selfie_challenge.dart';
import 'photo_challenge.dart';

/// Factory tạo Challenge từ ChallengeConfig.
///
/// Dùng pattern Factory Method để tách biệt logic tạo challenge
/// khỏi code sử dụng.
class ChallengeFactory {
  /// Tạo một instance Challenge từ config.
  /// Throws [ArgumentError] nếu type không được hỗ trợ.
  static Challenge create(ChallengeConfig config) {
    switch (config.type) {
      case 'math':
        return MathChallenge(
          difficulty: (config.params['difficulty'] as num?)?.toInt() ?? 1,
          questionCount: (config.params['questionCount'] as num?)?.toInt() ?? 3,
        );
      case 'shake':
        return ShakeChallenge(
          targetCount: (config.params['targetCount'] as num?)?.toInt() ?? 30,
          shakeThreshold:
              (config.params['shakeThreshold'] as num?)?.toDouble() ?? 15.0,
        );
      case 'qr':
        final hashes = (config.params['qrHashes'] as List<dynamic>?)
                ?.cast<String>() ??
            [];
        return QrChallenge(registeredHashes: hashes);
      case 'selfie':
        return SelfieChallenge(
          requireEyesOpen: config.params['requireEyesOpen'] as bool? ?? true,
          holdDurationSeconds:
              (config.params['holdDurationSeconds'] as num?)?.toInt() ?? 2,
        );
      case 'photo':
        return PhotoChallenge(
          referencePhotoPath:
              config.params['referencePhotoPath'] as String? ?? '',
          similarityThreshold:
              (config.params['similarityThreshold'] as num?)?.toDouble() ??
                  0.65,
        );
      default:
        throw ArgumentError('Unknown challenge type: ${config.type}');
    }
  }

  /// Tạo danh sách Challenge từ danh sách ChallengeConfig.
  static List<Challenge> createAll(List<ChallengeConfig> configs) {
    return configs.map(create).toList();
  }
}
