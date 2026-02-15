import 'package:mobx/mobx.dart';
import 'package:pokemon_api_test/features/pokemon_list/data/models/model_pokemon.dart';
import 'package:pokemon_api_test/features/pokemon_list/presentation/stores/pokemon_store.dart';

class FakePokemonStore implements PokemonStore {
  @override
  ReactiveContext get context => mainContext;

  final Observable<bool> _isLoading = Observable(false);
  final Observable<String?> _errorMessage = Observable(null);
  final Observable<PokemonModel?> _selectedPokemon = Observable(null);
  final Observable<int> _offset = Observable(0);

  @override
  int get limit => 20;

  @override
  ObservableList<PokemonModel> pokemonList = ObservableList<PokemonModel>();

  @override
  bool get isLoading => _isLoading.value;
  @override
  set isLoading(bool value) => Action(() => _isLoading.value = value)();

  @override
  String? get errorMessage => _errorMessage.value;
  @override
  set errorMessage(String? value) => Action(() => _errorMessage.value = value)();

  @override
  PokemonModel? get selectedPokemon => _selectedPokemon.value;
  @override
  set selectedPokemon(PokemonModel? value) => Action(() => _selectedPokemon.value = value)();

  @override
  int get offset => _offset.value;
  @override
  set offset(int value) => Action(() => _offset.value = value)();

  @override
  Future<void> fetchPokemons() async {}

  @override
  Future<void> fetchPokemonDetail(int id) async {}

  @override
  Future<void> playSound( {String path = '', bool lopping = false, double volume = 1.0}) async{}

  @override
  void nextPage() {}

  @override
  void previousPage() {}

  void setLoading(bool v) => isLoading = v;
  void setError(String? v) => errorMessage = v;
  void setSelected(PokemonModel? p) => selectedPokemon = p;
  void setOffset(int v) => offset = v;

  void setPokemons(List<PokemonModel> list) => Action(() {
    pokemonList
      ..clear()
      ..addAll(list);
  })();
}