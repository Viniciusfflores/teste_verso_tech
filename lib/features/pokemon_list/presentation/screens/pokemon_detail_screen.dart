import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import '../stores/pokemon_store.dart';

class PokemonDetail extends StatefulWidget {
  final int pokemonId;

  PokemonDetail({super.key, required this.pokemonId});

  @override
  State<PokemonDetail> createState() => _PokemonDetail();
}

class _PokemonDetail extends State<PokemonDetail> {
  final pokemonStore = GetIt.I<PokemonStore>();
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    pokemonStore.fetchPokemonDetail(widget.pokemonId);
    playSound();
  }

  void playSound() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      await _player.setAudioSource(
        AudioSource.asset('assets/audio/arcade-theme.wav'),
        preload: true,
      );
      await _player.setLoopMode(LoopMode.all);
      await _player.setVolume(0.4);
      await _player.play();
    } catch (e) {
      log('$e', name: 'SCREEN POKEMON INFO');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final pokemon = pokemonStore.selectedPokemon;
        bool loading = pokemonStore.isLoading;

        if (loading) {
          if (loading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.redAccent,
                  key: Key('loading'),
                ),
              ),
            );
          }
        }

        if (pokemonStore.errorMessage != null) {
          return Scaffold(
            appBar: AppBar(leading: const BackButton()),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    "Ocorreu um erro:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      pokemonStore.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Voltar"),
                  ),
                ],
              ),
            ),
          );
        }

        if (pokemon == null) {
          return const Scaffold(body: Center(child: Text('Carregando')));
        }

        return Scaffold(
          backgroundColor: _getColorByType(pokemon.types.firstOrNull),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Stack(
            children: [
              Positioned(
                top: 10,
                right: 20,
                child: Text(
                  '#${pokemon.id.toString().padLeft(3, '0')}',
                  style: TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pokemon.name.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: pokemon.types
                              .map((type) => _buildTypeBadge(type))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    flex: 3,
                    child: Hero(
                      tag: pokemon.id,
                      child: CachedNetworkImage(
                        imageUrl: pokemon.imageUrl,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: [
                            _buildWeightHeight(pokemon.weight, pokemon.height),
                            const SizedBox(height: 30),
                            _buildAbilities(pokemon.abilities),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTypeBadge(String type) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(type, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildWeightHeight(int weight, int height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _infoColumn('${weight / 10} kg', 'Peso', Icons.monitor_weight_outlined),
        _infoColumn('${height / 10} m', 'Altura', Icons.height),
      ],
    );
  }

  Widget _infoColumn(String value, String label, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildAbilities(List<String> abilities) {
    return Column(
      children: [
        const Text(
          "Habilidades",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: abilities.map((a) => Chip(label: Text(a))).toList(),
        ),
      ],
    );
  }

  Color _getColorByType(String? type) {
    switch (type) {
      case 'fire':
        return Colors.orangeAccent;
      case 'water':
        return Colors.blueAccent;
      case 'grass':
        return Colors.greenAccent;
      case 'electric':
        return Colors.yellow[700]!;
      case 'poison':
        return Colors.purpleAccent;
      case 'psychic':
        return Colors.pinkAccent;
      case 'rock':
        return Colors.grey;
      case 'ground':
        return Colors.brown;
      case 'bug':
        return Colors.lightGreen;
      case 'normal':
        return Colors.grey[400]!;
      case 'flying':
        return Colors.indigoAccent;
      case 'fighting':
        return Colors.redAccent;
      default:
        return Colors.redAccent;
    }
  }
}
