import 'package:dartz/dartz.dart';

import '../../constants/equation_ports.dart';
import '../errors/invalid_equation.dart';

class EquationValue {
  final String _equation;

  const EquationValue._(this._equation);

  get getValue => _equation;

  static bool _canPutPortNone(String equation, int loc) {
    return ((equation[loc] == EquationPorts.OR ||
            equation[loc] == EquationPorts.AND ||
            equation[loc] == ")") &&
        equation[loc - 1] != EquationPorts.NOT &&
        equation[loc - 1] != EquationPorts.NONE);
  }

  static String _addingPortNone(String equation) {
    String auxEquation = "";

    for (int i = 0; i < equation.length; i++) {
      if (_canPutPortNone(equation, i)) {
        auxEquation += EquationPorts.NONE + equation[i];
      } else {
        auxEquation += equation[i];
      }
    }

    auxEquation += auxEquation[auxEquation.length - 1] == "'" ? "" : "/";

    return auxEquation;
  }

  static Either<Exception, EquationValue> create({String equation = "A*B"}) {
    final result = _isEquationValid(equation);

    final value = result.fold((l) => l, (r) => r);

    if (value is InvalidEquationError) return Left(value);

    final valueWithNone = _addingPortNone(value);

    return Right(EquationValue._(valueWithNone));
  }

  static Either<InvalidEquationError, String> _isEquationValid(
    String equation,
  ) {
    if (equation.contains(EquationPorts.AND * 2)) {
      return Left(InvalidEquationError.create(
        message: "There are two or more ports AND togheter as [**]",
      ));
    } else if (equation.contains(EquationPorts.OR * 2)) {
      return Left(InvalidEquationError.create(
        message: "There are two or more ports OR togheter as [++]",
      ));
    } else if (equation.contains(EquationPorts.NOT * 2)) {
      return Left(InvalidEquationError.create(
        message: "There are two or more ports NOT togheter as ['']",
      ));
    } else if (equation.contains(EquationPorts.NONE * 2)) {
      return Left(InvalidEquationError.create(
        message: "There are two or more ports NONE togheter as [//]",
      ));
    }

    for (int i = 0; i < equation.length - 1; i++) {
      if (equation[i] == EquationPorts.NOT &&
          equation[i + 1] != EquationPorts.AND &&
          equation[i + 1] != EquationPorts.OR &&
          equation[i + 1] != ")") {
        return Left(InvalidEquationError.create(
          message:
              "Equation syntax error [" + equation[i] + equation[i + 1] + "]",
        ));
      }
    }

    int bracketOpen = 0, bracketClose = 0;

    for (int i = 0; i < equation.length; i++) {
      if (equation[i] == '(') {
        bracketOpen++;
      } else if (equation[i] == ')') {
        bracketClose++;
      }
    }

    if (bracketClose != bracketOpen) {
      return Left(InvalidEquationError.create(
        message: "There are some problem with the Brackets of your equation",
      ));
    }

    return Right(equation);
  }
}
