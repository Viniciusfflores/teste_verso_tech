import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/models/model_pokemon.dart';

class PokemonInfo extends StatelessWidget {
  final PokemonModel pokemon;

  final double chamfer;

  const PokemonInfo({
    super.key,
    required this.pokemon,
    this.chamfer = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/pokemonDetail', arguments: pokemon.id);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipPath(
              clipBehavior: Clip.antiAlias,
              clipper: _TopRightChamferClipper(chamfer: chamfer),
              child: Container(
                height: 45,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                color: Colors.grey[500],
                child: Text(
                  '#${pokemon.id.toString().padLeft(3, '0')}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Center(
                child: Hero(
                  tag: pokemon.id,
                  child: CachedNetworkImage(
                    imageUrl: pokemon.imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) =>
                    const CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                pokemon.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopRightChamferClipper extends CustomClipper<Path> {
  final double chamfer;
  _TopRightChamferClipper({required this.chamfer});

  @override
  Path getClip(Size size) {
    final c = chamfer.clamp(0.0, size.height);

    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - c, 0)
      ..lineTo(size.width, c)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant _TopRightChamferClipper oldClipper) {
    return oldClipper.chamfer != chamfer;
  }
}
