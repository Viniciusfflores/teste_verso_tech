import 'package:dio/dio.dart';

class PokemonRemoteDatasource {
  final Dio _dio;

  PokemonRemoteDatasource(this._dio);

  Future<Response> getPokemons({int offser =0, int limit = 20}) async {
    return await _dio.get('pokemon', queryParameters: {
      'offset': offser,
      'limit': limit,
    });
  }

}