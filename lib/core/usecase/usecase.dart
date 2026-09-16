import 'package:fpdart/fpdart.dart';

import '../error/failure.dart';

/// Base contract for domain use cases.
///
/// [DataType] is the successful result; [Params] is the input required to
/// execute the use case.
abstract class UseCase<DataType, Params> {
  Future<Either<Failure, DataType>> call(Params params);
}

/// Use when a use case needs no parameters.
class NoParams {
  const NoParams();
}
