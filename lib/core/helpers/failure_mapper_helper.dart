import 'dart:async';
import 'dart:io';

import '../error/exception.dart';
import '../error/failure.dart';

// Error messages
const String MISSING_SERVER_FAILURE_MESSAGE = 'No servers are configured.';
const String SERVER_FAILURE_MESSAGE = 'Failed to connect to server.';
const String CONNECTION_FAILURE_MESSAGE = 'No network connectivity.';
const String SETTINGS_FAILURE_MESSAGE = 'Required settings are missing.';
const String SOCKET_FAILURE_MESSAGE =
    'Failed to connect to Connection Address.';
const String TLS_FAILURE_MESSAGE = 'Failed to establish TLS/SSL connection.';
const String URL_FORMAT_FAILURE_MESSAGE = 'Incorrect URL format.';
const String TIMEOUT_FAILURE_MESSAGE = 'Connection to server timed out.';
const String JSON_FAILURE_MESSAGE = 'Failed to parse response.';
const String TERMINATE_FAILURE_MESSAGE = 'Failed to terminate the stream.';

// Error suggestions
const String MISSING_SERVER_SUGGESTION =
    'Please register with a Tautulli server.';
const String CHECK_CONNECTION_ADDRESS_SUGGESTION =
    'Check your Connection Address for errors.';
const String CHECK_SERVER_SETTINGS_SUGGESTION =
    'Please verify your connection settings.';
const String TIMEOUT_SUGGESTION =
    'Check your Connection Address for errors and make sure Tautulli can communicate with Plex.';
const String TERMINATE_SUGGESTION = 'Make sure the stream is still active.';

class FailureMapperHelper {
  /// Map [Exception] to corresponding [Failure].
  Failure mapExceptionToFailure(dynamic exception) {
    Failure failure;

    switch (exception.runtimeType) {
      case (MissingServerException):
        failure = MissingServerFailure();
        break;
      case (SettingsException):
        failure = SettingsFailure();
        break;
      case (ServerException):
        failure = ServerFailure();
        break;
      case (SocketException):
        failure = SocketFailure();
        break;
      case (TlsException):
        failure = TlsFailure();
        break;
      case (FormatException):
        failure = UrlFormatFailure();
        break;
      case (ArgumentError):
        failure = UrlFormatFailure();
        break;
      case (TimeoutException):
        failure = TimeoutFailure();
        break;
      case (JsonDecodeException):
        failure = JsonDecodeFailure();
        break;
    }

    return failure;
  }

  /// Maps [Failure] to appropriate message.
  String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case MissingServerFailure:
        return MISSING_SERVER_FAILURE_MESSAGE;
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case ConnectionFailure:
        return CONNECTION_FAILURE_MESSAGE;
      case SettingsFailure:
        return SETTINGS_FAILURE_MESSAGE;
      case SocketFailure:
        return SOCKET_FAILURE_MESSAGE;
      case TlsFailure:
        return TLS_FAILURE_MESSAGE;
      case UrlFormatFailure:
        return URL_FORMAT_FAILURE_MESSAGE;
      case TimeoutFailure:
        return TIMEOUT_FAILURE_MESSAGE;
      case JsonDecodeFailure:
        return JSON_FAILURE_MESSAGE;
      case TerminateFailure:
        return TERMINATE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }

  /// Maps [Failure] to appropriate suggestions.
  String mapFailureToSuggestion(Failure failure) {
    switch (failure.runtimeType) {
      case MissingServerFailure:
        return MISSING_SERVER_SUGGESTION;
      case ServerFailure:
        return CHECK_SERVER_SETTINGS_SUGGESTION;
      case SettingsFailure:
        return CHECK_SERVER_SETTINGS_SUGGESTION;
      case SocketFailure:
        return CHECK_CONNECTION_ADDRESS_SUGGESTION;
      case TlsFailure:
        return CHECK_CONNECTION_ADDRESS_SUGGESTION;
      case UrlFormatFailure:
        return CHECK_CONNECTION_ADDRESS_SUGGESTION;
      case TimeoutFailure:
        return TIMEOUT_SUGGESTION;
      case JsonDecodeFailure:
        return CHECK_CONNECTION_ADDRESS_SUGGESTION;
      case TerminateFailure:
        return TERMINATE_SUGGESTION;
      default:
        return '';
    }
  }
}