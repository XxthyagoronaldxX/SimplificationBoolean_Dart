import 'package:dartz/dartz.dart';
import 'equation_value.dart';

class BooleanEquationEntity {
  final EquationValue equation;

  const BooleanEquationEntity._(this.equation);

  static int indexEndOfABracket(String equation, int start) {
    int cont = 0;
    int closeBracket = 0;

    for (int j = start + 1; j < equation.length; j++) {
      if (equation[j] == "(") {
        cont++;
      } else if (equation[j] == ")" && cont == 0) {
        closeBracket = j;
        break;
      } else if (equation[j] == ")") {
        cont--;
      }
    }

    return closeBracket;
  }

  static Either<Exception, BooleanEquationEntity> create({
    String equation = 'A/*B/',
  }) {
    final result = EquationValue.create(equation: equation);

    final value = result.fold((l) => l, (r) => r);

    if (value is Exception) {
      return Left(value);
    }

    return Right(BooleanEquationEntity._(value));
  }
}
