import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_api_test/features/pokemon_list/presentation/screens/widgets/pokedex_card.dart';
import 'package:pokemon_api_test/features/pokemon_list/presentation/screens/widgets/pokemon_info.dart';
import '../stores/pokemon_store.dart';

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  final pokemonStore = GetIt.I<PokemonStore>();

  @override
  void initState() {
    super.initState();
    pokemonStore.fetchPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Pokédex',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.lightBlueAccent,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.white, blurRadius: 10)],
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Área da Tela da Pokedex
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[800]!, width: 4),
              ),
              child: Observer(
                builder: (_) {
                  if (pokemonStore.isLoading) {
                    return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
                  }

                  if (pokemonStore.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 60, color: Colors.red),
                          const SizedBox(height: 16),
                          const Text("Erro ao carregar dados", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(pokemonStore.errorMessage!),
                          TextButton(
                            onPressed: () => pokemonStore.fetchPokemons(),
                            child: const Text("Tentar novamente"),
                          )
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemCount: pokemonStore.pokemonList.length,
                    itemBuilder: (context, index) {
                      final pokemon = pokemonStore.pokemonList[index];
                      return PokedexCard(
                        key: ValueKey(pokemon.id),
                        chamfer: 20,
                        borderWidth: 6,
                        borderColor: Colors.grey,
                        backgroundColor: Colors.white,
                        child: PokemonInfo(
                          key: ValueKey(pokemon.id),
                          pokemon: pokemon,
                          chamfer: 20,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Painel de controle
          Container(
            padding: const EdgeInsets.only(bottom: 40, top: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Seta Esquerda
                Observer(builder: (_) {
                  return _buildNavButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: pokemonStore.previousPage,
                    enabled: pokemonStore.offset > 0,
                  );
                }),

                // Display de Página
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen[400],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black54, width: 3),
                  ),
                  child: Observer(builder: (_) {
                    return Text(
                      "PAGE: ${(pokemonStore.offset / 20).toInt() + 1}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                        letterSpacing: 1.2,
                      ),
                    );
                  }),
                ),

                // Seta Direita
                Observer(builder: (_) {
                  return _buildNavButton(
                    icon: Icons.arrow_forward_ios,
                    onTap: pokemonStore.nextPage,
                    enabled: true,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    bool isRunning = pokemonStore.isLoading;

    return GestureDetector(
      onTap: (enabled && !isRunning) ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: (enabled && !isRunning) ? 1.0 : 0.3,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
            boxShadow: [
              if (enabled && !isRunning)
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
            ],
            border: Border.all(color: Colors.grey[800]!, width: 2),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );

  }
}