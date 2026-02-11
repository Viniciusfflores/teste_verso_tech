import 'package:pokemon_api_test/features/pokemon_list/data/models/model_pokemon.dart';

PokemonModel bulbasaur() => PokemonModel(
  id: 1,
  name: 'Bulbasaur',
  imageUrl: 'https://example.com/1.png',
  types: ['grass'],
  weight: 69,
  height: 7,
  abilities: ['overgrow'],
);

PokemonModel pikachu() => PokemonModel(
  id: 25,
  name: 'Pikachu',
  imageUrl: 'https://example.com/25.png',
);
