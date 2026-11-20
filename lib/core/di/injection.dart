import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../database/app_database.dart';
import '../network/api_client.dart';

final GetIt sl = GetIt.instance;

/// Registers app-wide dependencies. Features add their own registrations here.
Future<void> configureDependencies() async {
  sl
    ..registerLazySingleton<Dio>(createApiClient)
    ..registerLazySingleton<AppDatabase>(AppDatabase.new);
}
