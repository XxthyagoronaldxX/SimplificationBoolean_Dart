import 'domain/entities/boolean_equation.dart';
import 'domain/errors/invalid_equation.dart';
import 'domain/usecases/resolve_brackets_usecase.dart';
import 'domain/usecases/resolve_buses_usecase.dart';

//D'+A/*B/+(A/*C'+A/*D/+(A/*B/*C/+A'*B'*C/)/)'+C/*D'
//D'+A/*B/+(A'+C/*A'+D'*(A'+B'+C'*A/+B/+C')/)/+C/*D'
//D'+A/*B/+A'+C/*A'+D'*A'+D'*B'+D'*C'*D'*A/+D'*B/+D'*C'+C/*D'

void main() {
  //String equation = "A/*B/+(A/*C'+A/*D/+(A/*B/*C/+A'*B'*C/)/)'+C/*D'";
  String equation = "D'+A*B+(A*C'+A*D+(A*B*C+A'*B'*C))'+C*D'";

  final result = BooleanEquationEntity.create(
    equation: equation,
  );

  final value = result.fold((l) => l, (r) => r);

  if (value is InvalidEquationError) {
    print(value.message);
  } else if (value is BooleanEquationEntity) {
    var test = value;

    print(test.equation.getValue);

    ResolveBusesUsecase resolveBusesUsecase = new ImplResolveBusesUsecase();

    final resultResolveBuses = resolveBusesUsecase.call(test);

    final valueResolveBuses = resultResolveBuses.fold((l) => l, (r) => r);

    if (valueResolveBuses is InvalidEquationError)
      print(valueResolveBuses.message);

    if (valueResolveBuses is BooleanEquationEntity) {
      test = valueResolveBuses;

      print(test.equation.getValue);

      ResolveBracketsUsecase resolveBracketsUsecase =
          new ImplResolveBracketsUsecase();

      final resultResolveBracket = resolveBracketsUsecase.call(test);

      final valueResolveBracket = resultResolveBracket.fold(
        (l) => l,
        ((r) => r),
      );

      if (valueResolveBracket is BooleanEquationEntity) {
        test = valueResolveBracket;

        print(test.equation.getValue);
      }
    }
  }
}
