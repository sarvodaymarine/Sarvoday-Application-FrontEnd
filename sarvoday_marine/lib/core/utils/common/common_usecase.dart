import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';

abstract class CommonUseCase<Type, Params> {
  Future<Either<CommonFailure, Type>> call(Params params);
}
