import 'package:absence_manager/domain/entities/entities.dart';

class FilterAbsencesByTypeUseCase {
  List<AbsenceEntity> call(String type, List<AbsenceEntity> allAbsences) {
    return allAbsences
        .where((absence) => absence.type.toLowerCase() == type.toLowerCase())
        .toList();
  }
}
