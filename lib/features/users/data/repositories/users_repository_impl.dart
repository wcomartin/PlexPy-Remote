import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_data_source.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersDataSource dataSource;
  final NetworkInfo networkInfo;
  final FailureMapperHelper failureMapperHelper;

  UsersRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
    @required this.failureMapperHelper,
  });

  @override
  Future<Either<Failure, List<User>>> getUsers({
    @required tautulliId,
    int grouping,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final usersList = await dataSource.getUsers(
          tautulliId: tautulliId,
          grouping: grouping,
          orderColumn: orderColumn,
          orderDir: orderDir,
          start: start,
          length: length,
          search: search,
        );
        return Right(usersList);
      } catch (exception) {
        final Failure failure =
            failureMapperHelper.mapExceptionToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}