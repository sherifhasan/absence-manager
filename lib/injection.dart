import 'package:absence_manager/application/absence_cubit.dart';
import 'package:get_it/get_it.dart';

import 'domain/app_repository.dart';
import 'infrastructure/app_repository_imp.dart';
import 'infrastructure/datasource/data_source.dart';
import 'infrastructure/datasource/local_data_source.dart';

final GetIt injection = GetIt.instance;

Future<void> setUp() async {
  await initLocators();
}

Future<void> initLocators() async {
  injection.registerSingleton<DataSource>(LocalDataSource());
  injection.registerSingleton<AppRepository>(AppRepositoryImp(injection.get()));
  injection.registerSingleton<AbsenceCubit>(
      AbsenceCubit(repository: injection.get()));
}
