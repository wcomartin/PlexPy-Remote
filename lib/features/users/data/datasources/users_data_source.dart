import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulliApi;
import '../../domain/entities/user.dart';
import '../../domain/entities/user_table.dart';
import '../models/user_model.dart';
import '../models/user_table_model.dart';

abstract class UsersDataSource {
  Future<List> getUserNames({
    @required tautulliId,
  });
  Future<List> getUsersTable({
    @required tautulliId,
    int grouping,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
  });
}

class UsersDataSourceImpl implements UsersDataSource {
  final tautulliApi.GetUserNames apiGetUserNames;
  final tautulliApi.GetUsersTable apiGetUsersTable;

  UsersDataSourceImpl({
    @required this.apiGetUserNames,
    @required this.apiGetUsersTable,
  });

  @override
  Future<List> getUserNames({
    @required tautulliId,
  }) async {
    final usersJson = await apiGetUserNames(tautulliId: tautulliId);

    final List<User> usersList = [];
    usersJson['response']['data'].forEach((item) {
      usersList.add(UserModel.fromJson(item));
    });

    return usersList;
  }

  @override
  Future<List> getUsersTable({
    @required tautulliId,
    int grouping,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
  }) async {
    final usersTableJson = await apiGetUsersTable(
      tautulliId: tautulliId,
      grouping: grouping,
      orderColumn: orderColumn,
      orderDir: orderDir,
      start: start,
      length: length,
      search: search,
    );

    final List<UserTable> usersTableList = [];
    usersTableJson['response']['data']['data'].forEach((item) {
      usersTableList.add(UserTableModel.fromJson(item));
    });

    return usersTableList;
  }
}