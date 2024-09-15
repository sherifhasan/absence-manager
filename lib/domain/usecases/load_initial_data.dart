import 'package:absence_manager/domain/app_repository.dart';

class LoadInitialDataUseCase {
  final AppRepository repository;

  LoadInitialDataUseCase(this.repository);

  Future<Map<String, dynamic>> call() async {
    final absences = await repository.absences();
    final members = await repository.members();
    return {
      'absences': absences,
      'members': members,
    };
  }
}
