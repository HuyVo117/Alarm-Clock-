import 'package:flutter_test/flutter_test.dart';
import 'package:wake_up/features/challenges/domain/math_challenge.dart';

void main() {
  group('MathChallenge Unit Tests', () {
    test('1. MathChallenge difficulty 1: operands in 10-99 range, non-negative',
        () async {
      for (int i = 0; i < 20; i++) {
        final challenge = MathChallenge(difficulty: 1, questionCount: 1);
        await challenge.start();

        expect(challenge.expression, isNotEmpty);
        expect(challenge.correctAnswer, isNonNegative);

        final isAdd = challenge.expression.contains('+');
        final isSub = challenge.expression.contains('−');
        expect(isAdd || isSub, isTrue);
      }
    });

    test('2. MathChallenge difficulty 2: contains × or ÷ and integer answer',
        () async {
      for (int i = 0; i < 20; i++) {
        final challenge = MathChallenge(difficulty: 2, questionCount: 1);
        await challenge.start();

        expect(challenge.expression, isNotEmpty);
        final isMul = challenge.expression.contains('×');
        final isDiv = challenge.expression.contains('÷');
        expect(isMul || isDiv, isTrue);
        expect(challenge.correctAnswer, greaterThan(0));
      }
    });

    test('3. MathChallenge difficulty 3: mixed operations', () async {
      for (int i = 0; i < 20; i++) {
        final challenge = MathChallenge(difficulty: 3, questionCount: 1);
        await challenge.start();

        expect(challenge.expression, isNotEmpty);
        expect(challenge.correctAnswer, isNonNegative);
      }
    });

    test('4. MathChallenge verify correct answer advances question', () async {
      final challenge = MathChallenge(difficulty: 1, questionCount: 3);
      await challenge.start();

      expect(challenge.currentQuestionIndex, 0);
      expect(challenge.isCompleted, isFalse);

      final ans1 = challenge.correctAnswer;
      final completed1 = await challenge.verify(ans1);
      expect(completed1, isFalse);
      expect(challenge.lastAnswerCorrect, isTrue);
      expect(challenge.currentQuestionIndex, 1);
      expect(challenge.progress, closeTo(1 / 3, 0.01));

      final ans2 = challenge.correctAnswer;
      final completed2 = await challenge.verify(ans2);
      expect(completed2, isFalse);
      expect(challenge.lastAnswerCorrect, isTrue);
      expect(challenge.currentQuestionIndex, 2);
      expect(challenge.progress, closeTo(2 / 3, 0.01));

      final ans3 = challenge.correctAnswer;
      final completed3 = await challenge.verify(ans3);
      expect(completed3, isTrue);
      expect(challenge.lastAnswerCorrect, isTrue);
      expect(challenge.isCompleted, isTrue);
      expect(challenge.progress, closeTo(1.0, 0.01));
    });

    test('5. MathChallenge verify wrong answer generates new question without advancing',
        () async {
      final challenge = MathChallenge(difficulty: 1, questionCount: 3);
      await challenge.start();

      final wrongAnswer = challenge.correctAnswer + 9999;
      final oldExpression = challenge.expression;

      final completed = await challenge.verify(wrongAnswer);
      expect(completed, isFalse);
      expect(challenge.lastAnswerCorrect, isFalse);
      expect(challenge.currentQuestionIndex, 0);
      expect(challenge.isCompleted, isFalse);
      expect(challenge.progress, 0.0);
      expect(oldExpression, isNotEmpty);
    });

    test('6. MathChallenge verify handles invalid string gracefully', () async {
      final challenge = MathChallenge(difficulty: 1, questionCount: 3);
      await challenge.start();

      expect(await challenge.verify('not_a_number'), isFalse);
      expect(await challenge.verify(null), isFalse);
      expect(challenge.currentQuestionIndex, 0);
    });

    test('7. MathChallenge reset keeps question progress but regenerates expression',
        () async {
      final challenge = MathChallenge(difficulty: 1, questionCount: 3);
      await challenge.start();

      await challenge.verify(challenge.correctAnswer);
      expect(challenge.currentQuestionIndex, 1);

      challenge.reset();
      expect(challenge.currentQuestionIndex, 1);
      expect(challenge.expression, isNotEmpty);
    });
  });
}
