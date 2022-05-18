class InvalidEquationError implements Exception {
  final String message;

  const InvalidEquationError._(this.message) : super();

  static create({String message = "InvalidEquationError"}) {
    return InvalidEquationError._(message);
  }
}
