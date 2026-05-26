import 'package:flutter/material.dart';
import 'core/di/injection.dart' as di;
import 'features/pokemon_list/presentation/screens/pokemon_detail_screen.dart';
import 'features/pokemon_list/presentation/screens/pokemon_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  print('🔥 Firebase Apps: ${Firebase.apps.length}');
  print('🔥 Firebase App Name: ${Firebase.app().name}');

  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  print('📊 Analytics habilitado!');

  await FirebaseAnalytics.instance.logEvent(
    name: 'app_started',
    parameters: {'timestamp': DateTime.now().toString()},
  );
  print('📊 Evento app_started enviado!');

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;


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
      navigatorObservers: [
        di.getIt<RouteObserver<ModalRoute>>(),
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
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
