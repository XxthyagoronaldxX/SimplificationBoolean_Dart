import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../../src/domain/entities/boolean_equation.dart';
import '../../../src/domain/errors/invalid_equation.dart';

void main() {
  group("=== BooleanEquationEntity ===", () {
    test("Should convert and return a correct BooleanEquationEntity", () {
      String equation = "A+B*C*D'";

      final result = BooleanEquationEntity.create(equation: equation);

      final value = result.fold((l) => l, (r) => r);

      expect((value as BooleanEquationEntity).equation.getValue, "A/+B/*C/*D'");
    });

    test(
      "Should return error [InvalidEquationError], two or more AND togheter",
      () {
        String equation = "A+B*C**DAD'";

        final result = BooleanEquationEntity.create(equation: equation);

        final value = result.fold((l) => l, (r) => r);

        expect(value is InvalidEquationError, true);
      },
    );

    test(
      "Should return error [InvalidEquationError], two or more OR togheter",
      () {
        String equation = "A+B*C++DAD'";

        final result = BooleanEquationEntity.create(equation: equation);

        final value = result.fold((l) => l, (r) => r);

        expect(value is InvalidEquationError, true);
      },
    );

    test(
      "Should return error [InvalidEquationError], two or more NONE togheter",
      () {
        String equation = "A+B*C//*DAD'";

        final result = BooleanEquationEntity.create(equation: equation);

        final value = result.fold((l) => l, (r) => r);

        expect(value is InvalidEquationError, true);
      },
    );

    test(
      "Should return error [InvalidEquationError], two or more NOT togheter",
      () {
        String equation = "A+B*C/*DAD''";

        final result = BooleanEquationEntity.create(equation: equation);

        final value = result.fold((l) => l, (r) => r);

        expect(value is InvalidEquationError, true);
      },
    );

    test(
      "Should return error [InvalidEquationError], syntax error [A/B]",
      () {
        String equation = "A'B*C/*DA";

        final result = BooleanEquationEntity.create(equation: equation);

        final value = result.fold((l) => l, (r) => r);

        expect(value is InvalidEquationError, true);
      },
    );
  });
}
