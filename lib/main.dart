import 'package:flutter/material.dart';
import 'core/di/injection.dart' as di;
import 'features/pokemon_list/presentation/screens/datail_screen.dart';
import 'features/pokemon_list/presentation/screens/pokemon_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const PokemonList(),
      routes: {
        '/pokemonDetail': (context) {
          final id = ModalRoute.of(context)?.settings.arguments as int;
          return PokemonDetail(pokemonId: id);
        },
      },
    );
  }
}
