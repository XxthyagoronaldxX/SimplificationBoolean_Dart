import 'package:dartz/dartz.dart';

import '../../constants/equation_ports.dart';
import '../entities/boolean_equation.dart';

abstract class ResolveBracketsUsecase {
  Either<Exception, BooleanEquationEntity> call(
    BooleanEquationEntity booleanEquationEntity,
  );
}

class ImplResolveBracketsUsecase implements ResolveBracketsUsecase {
  @override
  Either<Exception, BooleanEquationEntity> call(
    BooleanEquationEntity booleanEquationEntity,
  ) {
    try {
      String equation = booleanEquationEntity.equation.getValue;

      String equationResolved = _resolveBrackets(equation, 0, equation.length);

      final result = BooleanEquationEntity.create(equation: equationResolved);

      return result;
    } catch (error) {
      return Left(error);
    }
  }

  String _getEvidenceValue(String equation, int locBracket) {
    String evidence = equation[locBracket - 1];

    for (int i = locBracket - 2; i >= 0; i--) {
      if (equation[i] != EquationPorts.OR)
        evidence = equation[i] + evidence;
      else
        break;
    }

    return evidence;
  }

  String _resolveBrackets(String equation, int start, int end) {
    String auxEquation = equation;

    if (auxEquation.contains('(')) {
      int indexOfBracket = auxEquation.indexOf('(', start);
      int lastIndexOfBracket = BooleanEquationEntity.indexEndOfABracket(
        auxEquation,
        indexOfBracket,
      );
      bool isBracketIn = equation.contains('(', indexOfBracket + 1);
      bool isBracketOut = equation.contains('(', lastIndexOfBracket);

      if (auxEquation[indexOfBracket - 1] == EquationPorts.OR) {
        auxEquation = auxEquation.replaceFirst('(', '', indexOfBracket);
        auxEquation =
            auxEquation.replaceFirst(')/', '', lastIndexOfBracket - 1);
      } else {
        String evidence = _getEvidenceValue(auxEquation, indexOfBracket);
        String substringEquation = "";

        for (int i = indexOfBracket + 1; i < lastIndexOfBracket; i++) {
          if (auxEquation[i] != EquationPorts.NOT &&
              auxEquation[i] != EquationPorts.OR &&
              auxEquation[i] != EquationPorts.AND &&
              auxEquation[i] != EquationPorts.NONE) {
            substringEquation += evidence + auxEquation[i];
          } else {
            substringEquation += equation[i];
          }
        }

        auxEquation = auxEquation.replaceRange(
          indexOfBracket - evidence.length,
          lastIndexOfBracket + 2,
          substringEquation,
        );
      }

      if (isBracketIn) {
        return _resolveBrackets(
          auxEquation,
          indexOfBracket,
          lastIndexOfBracket - 2,
        );
      } else if (isBracketOut) {
        return _resolveBrackets(
          auxEquation,
          lastIndexOfBracket - 2,
          auxEquation.length,
        );
      }
    }

    return auxEquation;
  }
}
