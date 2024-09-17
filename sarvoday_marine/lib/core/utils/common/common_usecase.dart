import 'package:dartz/dartz.dart';

abstract class CommonUseCase<Type, Params> {
  Future<Either<String, Type>> call(Params params);
}
