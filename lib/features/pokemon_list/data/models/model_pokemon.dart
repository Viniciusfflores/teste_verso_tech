class PokemonModel{
  final int id;
  final String name;
  final String imageUrl;
  final List<String> abilities;
  final List<String> types;
  final int baseExperience;
  final List<String> moves;
  final List<String> stats;
  final List<String> cries;
  final int height;
  final int weight;

  PokemonModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.abilities = const [],
    this.types = const [],
    this.baseExperience = 0,
    this.moves = const [],
    this.stats = const [],
    this.cries = const [],
    this.height = 0,
    this.weight = 0,
  });

  factory PokemonModel.fromMap(Map<String, dynamic> map){
    final int id = map['id'] ?? int.parse(map['url'].split('/')[map['url'].split('/').length - 2]);

    return PokemonModel(
      id: id,
      name: map['name'],
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
      abilities: (map['abilities'] as List?)?.map((a) => a['ability']['name'].toString()).toList() ?? [],
      types: (map['types'] as List?)?.map((t) => t['type']['name'].toString()).toList() ?? [],
      baseExperience: map['base_experience'] ?? 0,
      moves: (map['moves'] as List?)?.map((m) => m['move']['name'].toString()).toList() ?? [],
      cries: map['cries'] is Map
          ? (map['cries'] as Map).values.map((v) => v.toString()).toList()
          : [],
      height: map['height'] ?? 0,
      weight: map['weight'] ?? 0,
    );
  }

}