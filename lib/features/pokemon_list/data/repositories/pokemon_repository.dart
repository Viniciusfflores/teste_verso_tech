import 'dart:developer';
import '../datasource/pokemon_remote_datasource.dart';
import '../models/model_pokemon.dart';

class PokemonRepository {
  final PokemonRemoteDatasource _remoteDatasource;

  PokemonRepository(this._remoteDatasource);

  Future<List<PokemonModel>> fetchPokemons({int offset = 0}) async {
    try{
      final response = await _remoteDatasource.getPokemons(offser: offset, limit: 20);
      final List results = response.data['results'];

      return results.map((json) => PokemonModel.fromMap(json)).toList();
    }catch(e){
      log('Falha ao carregar Pokemons: $e', name: 'PokemonRepository');

      throw Exception('Falha inesperada ao carregar a lista de Pokémons.');
    }
  }

  Future<PokemonModel> fetchPokemonDetail(int id) async {
    try {
      final response = await _remoteDatasource.getPokemonDetail(id);

      final result = response.data;

      return PokemonModel.fromMap(result);
    }catch(e){
      log('Falha ao detalhes dos Pokemons: $e', name: 'PokemonRepository');

      throw Exception('Falha inesperada ao carregar os detalhes do Pokémon.');
    }

  }

}