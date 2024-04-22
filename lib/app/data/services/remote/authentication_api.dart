import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../../../domain/either.dart';
import '../../../domain/enums.dart';

class AuthenticationAPI {
  AuthenticationAPI(this._client);

  final Client _client;
  final _baseUrl = 'https://api.themoviedb.org/3';
  final _apikey = 'cd64d88080c3955355139791bda28f8c';

  Future<String?> createRequestToken() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/authentication/token/new?api_key=$_apikey'),
      );

      if (response.statusCode == 200) {
        final json = Map<String, dynamic>.from(jsonDecode(response.body));

        return json['request_token'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Either<SignInFailure, String>> createSessionWithLogin({
    required String userName,
    required String password,
    required String requestToken,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(
          '$_baseUrl/authentication/token/validate_with_login?api_key=$_apikey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'username': 'JuanCarlosSuarezMarin',
            'password': 'sherlock0508',
            'request_token': 'adb167c9fc093a9bdf49398086f20a5e5d5a3795'
          },
        ),
      );

      switch (response.statusCode) {
        case 200:
          final json = Map<String, dynamic>.from(jsonDecode(response.body));

          final newRequestToken = json['request_token'] as String;
          return Either.right(newRequestToken);

        case 401:
          return Either.left(SignInFailure.unauthorized);
        case 404:
          return Either.left(SignInFailure.notFound);
        default:
          return Either.left(SignInFailure.unknown);
      }
    } catch (exception) {
      if (exception is SocketException) {
        Either.left(SignInFailure.network);
      }
      return Either.left(SignInFailure.unknown);
    }
  }

  Future<Either<SignInFailure, String>> createSession(
      String requestToken) async {
    try {
      final response = await _client.post(
          Uri.parse('$_baseUrl/authentication/session/new?api_key=$_apikey'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'request_token': requestToken,
          }));

      if (response.statusCode == 200) {
        final json = Map<String, dynamic>.from(jsonDecode(response.body));
        final sessionId = json['session_id'] as String;
        return Either.right(sessionId);
      }
      return Either.left(SignInFailure.unknown);
    } catch (exception) {
      if (exception is SocketException) {
        return Either.left(SignInFailure.network);
      }
      return Either.left(SignInFailure.unknown);
    }
  }
}
