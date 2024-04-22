import 'dart:convert';

import '../../../domain/either.dart';
import '../../../domain/enums.dart';
import '../../http/http.dart';

class AuthenticationAPI {
  AuthenticationAPI(this._http);

  final Http _http;

  Future<Either<SignInFailure, String>> createRequestToken() async {
    final result = await _http.request(
      '/authentication/token/new',
    );

    return result.when(
      (failure) {
        if (failure.exception is NetWorkException) {
          return Either.left(SignInFailure.network);
        }
        return Either.left(SignInFailure.unknown);
      },
      (responseBody) {
        final json = Map<String, dynamic>.from(jsonDecode(responseBody));
        return Either.right(json['request_token']);
      },
    );
  }

  Future<Either<SignInFailure, String>> createSessionWithLogin({
    required String userName,
    required String password,
    required String requestToken,
  }) async {
    final result = await _http.request(
        '/authentication/token/validate_with_login',
        method: HttpMethod.post,
        body: {
          'username': userName,
          'password': password,
          'request_token': requestToken
        });

    return result.when((failure) {
      final statusCode = failure.statusCode;
      if (statusCode != null) {
        switch (statusCode) {
          case 401:
            return Either.left(SignInFailure.unauthorized);
          case 404:
            return Either.left(SignInFailure.notFound);
          default:
            return Either.left(SignInFailure.unknown);
        }
      }

      if (failure.exception is NetWorkException) {
        return Either.left(SignInFailure.network);
      }
      return Either.left(SignInFailure.unknown);
    }, (responseBody) {
      final json = Map<String, dynamic>.from(jsonDecode(responseBody));

      final newRequestToken = json['request_token'] as String;
      return Either.right(newRequestToken);
    });
  }

  Future<Either<SignInFailure, String>> createSession(
      String requestToken) async {
    final result = await _http
        .request('/authentication/session/new', method: HttpMethod.post, body: {
      'request_token': requestToken,
    });

    return result.when((failure) {
      if (failure.exception is NetWorkException) {
        return Either.left(SignInFailure.network);
      }
      return Either.left(SignInFailure.unknown);
    }, (responseBody) {
      final json = Map<String, dynamic>.from(jsonDecode(responseBody));
      final sessionId = json['session_id'] as String;
      return Either.right(sessionId);
    });
  }
}
