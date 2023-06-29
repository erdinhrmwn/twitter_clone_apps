import 'package:fpdart/fpdart.dart';

class Failure {
  final String message;
  final StackTrace stackTrace;

  Failure(this.message, this.stackTrace);
}

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;

// class Success {
//   final String message;
//   final Map<String, dynamic> data;

// }