import 'package:dartz/dartz.dart';

import '../../constants/equation_ports.dart';
import '../entities/boolean_equation.dart';

abstract class ResolveBusesUsecase {
  Either<Exception, BooleanEquationEntity> call(
      BooleanEquationEntity booleanEquationEntity);
}

class ImplResolveBusesUsecase implements ResolveBusesUsecase {
  @override
  Either<Exception, BooleanEquationEntity> call(
      BooleanEquationEntity booleanEquationEntity) {
    try {
      String equation = booleanEquationEntity.equation.getValue;

      String equationResolved = _resolveBuses(equation, 0, equation.length);

      final result = BooleanEquationEntity.create(equation: equationResolved);

      return result;
    } catch (error) {
      return Left(error);
    }
  }

  String _reverseEquation(String equation) {
    String auxEquation = equation;

    for (int i = 0; i < auxEquation.length; i++) {
      if (auxEquation[i] == '(') {
        i = BooleanEquationEntity.indexEndOfABracket(equation, i);
      }

      if (auxEquation[i] == EquationPorts.OR) {
        auxEquation = auxEquation.replaceFirst(
          EquationPorts.OR,
          EquationPorts.AND,
          i,
        );
      } else if (auxEquation[i] == EquationPorts.AND) {
        auxEquation = auxEquation.replaceFirst(
          EquationPorts.AND,
          EquationPorts.OR,
          i,
        );
      } else if (auxEquation[i] == EquationPorts.NONE) {
        auxEquation = auxEquation.replaceFirst(
          EquationPorts.NONE,
          EquationPorts.NOT,
          i,
        );
      } else if (auxEquation[i] == EquationPorts.NOT) {
        auxEquation = auxEquation.replaceFirst(
          EquationPorts.NOT,
          EquationPorts.NONE,
          i,
        );
      }
    }

    return auxEquation;
  }

  String _resolveBuses(String equation, int start, int end) {
    String auxEquation = equation;

    if (equation.contains("(", start)) {
      int indexOfBracket = equation.indexOf('(', start);
      int lastIndexOfBracket = BooleanEquationEntity.indexEndOfABracket(
        equation,
        indexOfBracket,
      );
      bool isBracketIn = equation.contains('(', indexOfBracket + 1);
      bool isBracketOut = equation.contains('(', lastIndexOfBracket);

      if (equation[lastIndexOfBracket + 1] == "'") {
        String reversedEquationSubstring = _reverseEquation(
          auxEquation.substring(indexOfBracket + 1, lastIndexOfBracket),
        );

        auxEquation = auxEquation.replaceRange(
          indexOfBracket,
          lastIndexOfBracket + 2,
          '(' + reversedEquationSubstring + ')' + EquationPorts.NONE,
        );
      }

      if (isBracketIn) {
        return _resolveBuses(
          auxEquation,
          indexOfBracket + 1,
          lastIndexOfBracket,
        );
      } else if (isBracketOut) {
        return _resolveBuses(
          auxEquation,
          lastIndexOfBracket,
          auxEquation.length,
        );
      }
    }

    return auxEquation;
  }
}
