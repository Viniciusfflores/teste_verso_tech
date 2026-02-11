import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../../features/pokemon_list/presentation/stores/pokemon_store.dart';
import '../network/api/api_service.dart';
import '../../features/pokemon_list/data/datasource/pokemon_remote_datasource.dart';
import '../../features/pokemon_list/data/repositories/pokemon_repository.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton<ApiService>(() => ApiService());

  getIt.registerLazySingleton<Dio>(() => getIt<ApiService>().dio);

  getIt.registerLazySingleton<PokemonRemoteDatasource>(
        () => PokemonRemoteDatasource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<PokemonRepository>(
        () => PokemonRepository(getIt<PokemonRemoteDatasource>()),
  );

  getIt.registerFactory<PokemonStore>(
        () => PokemonStore(getIt<PokemonRepository>()),
  );
}