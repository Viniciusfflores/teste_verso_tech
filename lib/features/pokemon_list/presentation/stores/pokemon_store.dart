import 'package:mobx/mobx.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/services/audio_service.dart';
import '../../data/models/model_pokemon.dart';
import '../../data/repositories/pokemon_repository.dart';

part 'pokemon_store.g.dart';

class PokemonStore = _PokemonStoreBase with _$PokemonStore;

abstract class _PokemonStoreBase with Store {
  final PokemonRepository _pokemonRepository;
  final AudioService _audioService;

  _PokemonStoreBase(this._pokemonRepository, this._audioService);

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
      //log('Erro ao buscar Pokémons: $e', name: 'PokemonStore');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> playSound({
    String path = '',
    bool lopping = false,
    double volume = 1.0})async
  {
    _audioService.playSfx(path: path, volume: volume, loop: lopping);
  }

  @action
  void nextPage() {
    offset += limit;
    _audioService.playSfx(path: 'assets/audio/button7.wav', volume: 1.3);
    fetchPokemons();
  }

  @action
  void previousPage() {
    if (offset >= limit) {
      offset -= limit;
      _audioService.playSfx(path: 'assets/audio/button7.wav', volume: 1.3);
      fetchPokemons();
    }
  }

  @action
  Future<void> fetchPokemonDetail(int id) async {
    try{
      isLoading = true;
      errorMessage = null;
      selectedPokemon = null;

      final result = await _pokemonRepository.fetchPokemonDetail(id);

      selectedPokemon = result;
    }catch(e) {
      if (e is PokemonException) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Falha ao carregar Detalhes';
      }
      //log('Erro ao buscar detalhes do Pokémon: $e', name: 'PokemonStore');
    }finally{
      isLoading = false;
    }
  }

}

