import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:pokemon_api_test/features/pokemon_list/presentation/screens/widgets/pokemon_info.dart';
import '../fixtures/pokemon_fixtures.dart';
import '../helpers/test_app.dart';

void main() {
  testWidgets('PokemonInfo: renderiza nome e id', (tester) async {
    final pokemon = bulbasaur();

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        wrapWithApp(
          PokemonInfo(pokemon: pokemon),
        ),
      );
      await tester.pump();
    });

    expect(find.text('Bulbasaur'), findsOneWidget);
    expect(find.text('#001'), findsOneWidget);
  });

  testWidgets('PokemonInfo: renderiza imagem (CachedNetworkImage)', (tester) async {
    final pokemon = bulbasaur();

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        wrapWithApp(
          PokemonInfo(pokemon: pokemon),
        ),
      );
      await tester.pump();
    });

    expect(find.byType(CachedNetworkImage), findsOneWidget);

    expect(find.text('Bulbasaur'), findsOneWidget);
  });
}
