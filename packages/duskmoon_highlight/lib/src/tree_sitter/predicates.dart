import 'model.dart';

/// Text predicates are evaluated against entire query matches, including all
/// occurrences of quantified captures (rather than individual capture events).
final class QueryPredicates {
  final List<List<List<({bool capture, String value})>>> patterns;
  final _regexes = <String, RegExp>{};

  QueryPredicates(List<dynamic> data)
      : patterns = [
          for (final pattern in data)
            [
              for (final predicate in pattern as List)
                [
                  for (final step in predicate as List)
                    (
                      capture: (step as Map)['capture'] as bool,
                      value: step['value'] as String,
                    ),
                ],
            ],
        ] {
    for (final pattern in patterns) {
      for (final predicate in pattern) {
        final operator = predicate.first.value;
        if (!const {
          'eq?',
          'not-eq?',
          'any-eq?',
          'any-not-eq?',
          'match?',
          'not-match?',
          'any-match?',
          'any-not-match?',
          'any-of?',
          'not-any-of?',
          'set!',
        }.contains(operator)) {
          throw UnsupportedError(
              'Unsupported Tree-sitter predicate #$operator');
        }
        final valid = operator == 'set!'
            ? (predicate.length == 2 || predicate.length == 3) &&
                predicate.every((step) => !step.capture)
            : operator.endsWith('of?')
                ? predicate.length >= 2 &&
                    predicate[1].capture &&
                    predicate.skip(2).every((step) => !step.capture)
                : predicate.length == 3 &&
                    predicate[1].capture &&
                    (!operator.contains('match?') || !predicate[2].capture);
        if (!valid) {
          throw FormatException('Invalid Tree-sitter predicate #$operator');
        }
        if (operator.contains('match?')) {
          _regexes.putIfAbsent(
              predicate[2].value, () => RegExp(predicate[2].value));
        }
      }
    }
  }

  int priority(int index) {
    var priority = 0;
    for (final predicate in patterns[index]) {
      if (predicate.length >= 3 &&
          predicate[0].value == 'set!' &&
          predicate[1].value == 'priority') {
        priority = int.tryParse(predicate[2].value) ?? 0;
      }
    }
    return priority;
  }

  bool accepts(int index, List<SyntaxCapture> captures, String source) {
    List<String> values(({bool capture, String value}) operand) =>
        operand.capture
            ? [
                for (final capture in captures)
                  if (capture.name == operand.value)
                    source.substring(capture.from, capture.to),
              ]
            : [operand.value];
    for (final predicate in patterns[index]) {
      final operator = predicate.first.value;
      if (operator == 'set!') continue;
      final left = values(predicate[1]);
      final negate = operator.contains('not-');
      final any = operator.startsWith('any-') && !operator.endsWith('of?');
      if (operator.endsWith('of?')) {
        final choices = predicate.skip(2).map((item) => item.value);
        final accepted =
            left.isEmpty ? negate : left.every(choices.contains) != negate;
        if (!accepted) return false;
        continue;
      }
      if (operator.contains('match?') && left.isEmpty) {
        if (!negate) return false;
        continue;
      }
      final right = values(predicate[2]);
      bool check(String value) {
        if (operator.contains('eq?')) {
          // Official web-tree-sitter compares each left capture with any right
          // capture, including the negated comparison for #not-eq?.
          return right.any((other) => (value == other) != negate);
        }
        return _regexes[right.single]!.hasMatch(value) != negate;
      }

      if (!(any ? left.any(check) : left.every(check))) return false;
    }
    return true;
  }
}
