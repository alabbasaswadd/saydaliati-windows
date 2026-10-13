import 'package:saydaliati/core/result/result.dart';

/// Contract for a use case that takes parameters of type [In] and produces [Out].
///
/// A use case is a single, named business operation ("create a sale",
/// "dispense a medicine"). It exists to keep meaningful domain logic out of
/// notifiers and widgets. Do **not** create a use case for every trivial getter —
/// only where it earns the separation.
///
/// Every use case returns a [Result], so failure handling is uniform and the
/// presentation layer never deals with exceptions.
abstract interface class UseCase<Out, In> {
  Future<Result<Out>> call(In params);
}

/// Contract for a use case that needs no parameters.
abstract interface class UseCaseNoParams<Out> {
  Future<Result<Out>> call();
}

/// Explicit "no parameters" marker for [UseCase] implementations that model an
/// operation without inputs but still want the uniform [UseCase] shape.
final class NoParams {
  const NoParams();
}
