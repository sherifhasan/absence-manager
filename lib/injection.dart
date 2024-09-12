import 'package:absence_manager/application/absence_cubit.dart';
import 'package:get_it/get_it.dart';

import 'domain/app_repository.dart';
import 'infrastructure/app_repository_imp.dart';
import 'infrastructure/datasource/data_source.dart';
import 'infrastructure/datasource/local_data_source.dart';

final GetIt getIt = GetIt.instance;

Future<void> setUp() async {
  await initLocators();
}

Future<void> initLocators() async {
  getIt.registerSingleton<DataSource>(LocalDataSource());
  getIt.registerSingleton<AppRepository>(AppRepositoryImp(getIt.get()));
  getIt.registerSingleton<AbsenceCubit>(AbsenceCubit(repository: getIt.get()));
}
