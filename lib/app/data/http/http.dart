import 'dart:io';

import 'package:http/http.dart';

import '../../domain/either.dart';

class Http {
  Http(this._client, this._baseUrl, this._apiKey);

  final Client _client;
  final String _baseUrl;
  final String _apiKey;

  Future<Either<HttpFailure, String>> request(
    String path, {
    HttpMethod method = HttpMethod.get,
    Map<String, String> headers = const {},
    Map<String, String> queryParameters = const {},
  }) async {
    try {
      Uri url = Uri.parse(path.startsWith('http') ? path : '$_baseUrl$path');
      if (queryParameters.isNotEmpty) {
        url = url.replace(queryParameters: queryParameters);
      }

      late final Response response;

      headers = {'Content-Type': 'application/json', ...headers};

      switch (method) {
        case HttpMethod.get:
          response = await _client.get(url);
          break;
        case HttpMethod.post:
          response = await _client.post(url);
          break;
        case HttpMethod.patch:
          response = await _client.patch(url);
          break;
        case HttpMethod.put:
          response = await _client.put(url);
          break;
        case HttpMethod.delete:
          response = await _client.delete(url);
          break;
      }

      final statusCode = response.statusCode;

      if (statusCode >= 200 && statusCode < 300) {
        return Either.right(response.body);
      }

      return Either.left(HttpFailure(statusCode: statusCode));
    } catch (exception) {
      if (exception is SocketException || exception is ClientException) {
        return Either.left(
          HttpFailure(
            exception: NetWorkException(),
          ),
        );
      }

      return Either.left(
        HttpFailure(
          exception: exception,
        ),
      );
    }
  }
}

class HttpFailure {
  HttpFailure({
    this.statusCode,
    this.exception,
  });
  final int? statusCode;
  final Object? exception;
}

class NetWorkException {}

enum HttpMethod { get, post, patch, put, delete }
