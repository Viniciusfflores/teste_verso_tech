import 'package:get_it/get_it.dart';

Future<void> resetGetIt() async {
  await GetIt.I.reset();
}
