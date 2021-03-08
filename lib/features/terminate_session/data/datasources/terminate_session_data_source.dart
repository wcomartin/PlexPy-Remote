import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulliApi;

abstract class TerminateSessionDataSource {
  /// Calls the TautulliApi to terminate a stream.
  ///
  /// Returns a bool based on success. Otherwise throws an [Exception].
  Future<bool> call({
    @required String tautulliId,
    @required String sessionId,
    String message,
  });
}

class TerminateSessionDataSourceImpl implements TerminateSessionDataSource {
  final tautulliApi.TerminateSession apiTerminateSession;

  TerminateSessionDataSourceImpl({
    @required this.apiTerminateSession,
  });

  @override
  Future<bool> call({
    @required String tautulliId,
    @required String sessionId,
    String message,
  }) async {
    final terminateJson = await apiTerminateSession(
      tautulliId: tautulliId,
      sessionId: sessionId,
      message: message,
    );

    if (terminateJson['response']['result'] == 'success') {
      return true;
    }

    return false;
  }
}