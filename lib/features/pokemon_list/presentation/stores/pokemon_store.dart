import 'dart:developer';
import 'package:mobx/mobx.dart';
import '../../../../core/errors/app_exception.dart';
import '../../data/models/model_pokemon.dart';
import '../../data/repositories/pokemon_repository.dart';

part 'pokemon_store.g.dart';

class PokemonStore = _PokemonStoreBase with _$PokemonStore;

abstract class _PokemonStoreBase with Store {
  final PokemonRepository _pokemonRepository;

  _PokemonStoreBase(this._pokemonRepository);

  @observable
  int offset = 0;

  final int limit = 20;

  @observable
  ObservableList<PokemonModel> pokemonList = ObservableList<PokemonModel>();

  @observable
  PokemonModel? selectedPokemon;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> fetchPokemons() async {
    try {
      isLoading = true;
      errorMessage = null;

      final result = await _pokemonRepository.fetchPokemons(offset: offset);

      pokemonList.clear();
      pokemonList.addAll(result);
    } catch (e) {
      if(e is PokemonException){
        errorMessage = e.message;
      }else {
        errorMessage = 'Falha ao carregar Pokemons';
      }
      log('Erro ao buscar Pokémons: $e', name: 'PokemonStore');
    } finally {
      isLoading = false;
    }
  }

  @action
  void nextPage() {
    offset += limit;
    fetchPokemons();
  }

  @action
  void previousPage() {
    if (offset >= limit) {
      offset -= limit;
      fetchPokemons();
    }
  }

}

