import 'dart:math';

import 'challenge.dart';

/// Thử thách giải toán: sinh ngẫu nhiên câu toán, phải trả lời đúng N câu.
///
/// 3 mức khó:
/// - 1 (Dễ): cộng/trừ số 1-2 chữ số
/// - 2 (Trung bình): nhân/chia số 1-2 chữ số
/// - 3 (Khó): phép hỗn hợp 2-3 chữ số
///
/// Logic thuần Dart, không phụ thuộc UI hoặc plugin.
class MathChallenge implements Challenge {
  final int difficulty;
  final int questionCount;
  final Random _random;

  int _currentQuestion = 0;
  String _expression = '';
  int _correctAnswer = 0;
  bool _lastAnswerCorrect = false;

  MathChallenge({
    this.difficulty = 1,
    this.questionCount = 3,
    Random? random,
  }) : _random = random ?? Random();

  @override
  String get type => 'math';

  @override
  Map<String, dynamic> get config => {
        'difficulty': difficulty,
        'questionCount': questionCount,
      };

  @override
  bool get isCompleted => _currentQuestion >= questionCount;

  @override
  double get progress =>
      questionCount > 0 ? _currentQuestion / questionCount : 0.0;

  /// Câu toán hiện tại dạng chuỗi, ví dụ "23 + 15"
  String get expression => _expression;

  /// Đáp án đúng của câu hiện tại (dùng cho testing)
  int get correctAnswer => _correctAnswer;

  /// Câu đang ở thứ mấy (0-indexed)
  int get currentQuestionIndex => _currentQuestion;

  /// Cho biết câu trả lời gần nhất là đúng hay sai
  bool get lastAnswerCorrect => _lastAnswerCorrect;

  @override
  Future<void> start() async {
    _currentQuestion = 0;
    _lastAnswerCorrect = false;
    _generateQuestion();
  }

  @override
  Future<bool> verify(dynamic answer) async {
    final userAnswer = answer is int ? answer : int.tryParse(answer.toString());
    if (userAnswer == null) {
      _lastAnswerCorrect = false;
      return false;
    }

    if (userAnswer == _correctAnswer) {
      _lastAnswerCorrect = true;
      _currentQuestion++;
      if (!isCompleted) {
        _generateQuestion();
      }
      return isCompleted;
    } else {
      _lastAnswerCorrect = false;
      // Sai → sinh câu mới, không tăng progress
      _generateQuestion();
      return false;
    }
  }

  @override
  void reset() {
    // Reset giữ progress hiện tại, chỉ sinh câu mới
    _lastAnswerCorrect = false;
    _generateQuestion();
  }

  @override
  void dispose() {
    // Không có tài nguyên cần giải phóng
  }

  /// Sinh câu toán mới dựa trên mức khó.
  void _generateQuestion() {
    switch (difficulty) {
      case 1:
        _generateEasy();
        break;
      case 2:
        _generateMedium();
        break;
      case 3:
        _generateHard();
        break;
      default:
        _generateEasy();
    }
  }

  /// Mức 1: cộng/trừ số 1-2 chữ số
  void _generateEasy() {
    final a = _random.nextInt(90) + 10; // 10-99
    final b = _random.nextInt(90) + 10; // 10-99
    final isAdd = _random.nextBool();

    if (isAdd) {
      _expression = '$a + $b';
      _correctAnswer = a + b;
    } else {
      // Đảm bảo kết quả không âm
      final big = max(a, b);
      final small = min(a, b);
      _expression = '$big − $small';
      _correctAnswer = big - small;
    }
  }

  /// Mức 2: nhân/chia số 1-2 chữ số
  void _generateMedium() {
    final isMultiply = _random.nextBool();

    if (isMultiply) {
      final a = _random.nextInt(9) + 2; // 2-10
      final b = _random.nextInt(9) + 2; // 2-10
      _expression = '$a × $b';
      _correctAnswer = a * b;
    } else {
      // Chia: sinh sao cho chia hết
      final b = _random.nextInt(9) + 2; // 2-10
      final quotient = _random.nextInt(9) + 2; // 2-10
      final a = b * quotient;
      _expression = '$a ÷ $b';
      _correctAnswer = quotient;
    }
  }

  /// Mức 3: phép hỗn hợp 2-3 chữ số
  void _generateHard() {
    final variant = _random.nextInt(3);

    switch (variant) {
      case 0:
        // a + b × c (nhân trước)
        final a = _random.nextInt(90) + 10; // 10-99
        final b = _random.nextInt(9) + 2; // 2-10
        final c = _random.nextInt(9) + 2; // 2-10
        _expression = '$a + $b × $c';
        _correctAnswer = a + b * c;
        break;
      case 1:
        // a × b + c
        final a = _random.nextInt(9) + 2; // 2-10
        final b = _random.nextInt(9) + 2; // 2-10
        final c = _random.nextInt(90) + 10; // 10-99
        _expression = '$a × $b + $c';
        _correctAnswer = a * b + c;
        break;
      case 2:
        // a − b + c (đảm bảo không âm)
        final a = _random.nextInt(400) + 100; // 100-499
        final b = _random.nextInt(90) + 10; // 10-99
        final c = _random.nextInt(90) + 10; // 10-99
        _expression = '$a − $b + $c';
        _correctAnswer = a - b + c;
        break;
    }
  }
}
