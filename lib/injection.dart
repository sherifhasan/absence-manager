import 'package:absence_manager/application/absence_cubit.dart';
import 'package:absence_manager/domain/usecases/usecases.dart';
import 'package:get_it/get_it.dart';
import 'package:absence_manager/domain/app_repository.dart';
import 'package:absence_manager/infrastructure/app_repository_imp.dart';
import 'package:absence_manager/infrastructure/datasource/data_source.dart';
import 'package:absence_manager/infrastructure/datasource/local_data_source.dart';

final GetIt injection = GetIt.instance;

Future<void> setUpInjections() async {
  await initLocators();
}

Future<void> initLocators() async {
  // Register DataSource if not already registered
  if (!injection.isRegistered<DataSource>()) {
    injection.registerSingleton<DataSource>(LocalDataSource());
  }

  // Register AppRepository if not already registered
  if (!injection.isRegistered<AppRepository>()) {
    injection
        .registerSingleton<AppRepository>(AppRepositoryImp(injection.get()));
  }

  await registerUseCases();

  // Register AbsenceCubit if not already registered
  if (!injection.isRegistered<AbsenceCubit>()) {
    injection.registerSingleton<AbsenceCubit>(
      AbsenceCubit(
        repository: injection.get<AppRepository>(), // Injecting repository
        perPage: 10,
      ),
    );
  }
}

Future<void> registerUseCases() async {
  // Register Use Cases
  if (!injection.isRegistered<LoadInitialDataUseCase>()) {
    injection.registerSingleton<LoadInitialDataUseCase>(
      LoadInitialDataUseCase(injection.get<AppRepository>()),
    );
  }

  if (!injection.isRegistered<LoadMoreAbsencesUseCase>()) {
    injection.registerSingleton<LoadMoreAbsencesUseCase>(
      LoadMoreAbsencesUseCase(perPage: 10), // Pass the perPage value if needed
    );
  }

  if (!injection.isRegistered<FilterAbsencesByTypeUseCase>()) {
    injection.registerSingleton<FilterAbsencesByTypeUseCase>(
      FilterAbsencesByTypeUseCase(),
    );
  }

  if (!injection.isRegistered<FilterAbsencesByDateUseCase>()) {
    injection.registerSingleton<FilterAbsencesByDateUseCase>(
      FilterAbsencesByDateUseCase(),
    );
  }
}
