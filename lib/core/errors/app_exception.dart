class PokemonException implements Exception {
  final String message;
  PokemonException(this.message);

  @override
  String toString() => message;
}