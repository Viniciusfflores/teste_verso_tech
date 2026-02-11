import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:pokemon_api_test/features/pokemon_list/presentation/screens/pokemon_detail_screen.dart';
import 'package:pokemon_api_test/features/pokemon_list/presentation/stores/pokemon_store.dart';
import '../fakes/fake_pokemon_store.dart';
import '../fixtures/pokemon_fixtures.dart';
import '../helpers/test_app.dart';

void main() {
  setUp(() async {
    await GetIt.I.reset();
  });

  testWidgets('Detail: mostra loading quando isLoading = true', (tester) async {
    final store = FakePokemonStore()
      ..setLoading(true)
      ..setSelected(null);
    GetIt.I.registerSingleton<PokemonStore>(store);

    await tester.pumpWidget(wrapWithApp(PokemonDetail(pokemonId: 1)));
    await tester.pump();

    expect(find.byKey(const Key('loading')), findsOneWidget);
  });

  testWidgets('Detail: mostra erro quando errorMessage != null', (tester) async {
    final store = FakePokemonStore()
      ..setLoading(false)
      ..setError('Falha ao carregar Detalhes')
      ..setSelected(null);
    GetIt.I.registerSingleton<PokemonStore>(store);

    await tester.pumpWidget(wrapWithApp(PokemonDetail(pokemonId: 1)));
    await tester.pump();

    expect(find.textContaining('Falha ao carregar Detalhes'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });

  testWidgets('Detail: mostra nome quando pokemon carregou', (tester) async {
    final store = FakePokemonStore()
      ..setLoading(false)
      ..setError(null)
      ..setSelected(bulbasaur());
    GetIt.I.registerSingleton<PokemonStore>(store);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(wrapWithApp(PokemonDetail(pokemonId: 1)));
      await tester.pump();
    });

    expect(find.text('BULBASAUR'), findsOneWidget);
  });
}
