import 'package:absence_manager/domain/entities/entities.dart';

class FilterAbsencesByDateUseCase {
  List<AbsenceEntity> call(
    DateTime startDate,
    DateTime endDate,
    List<AbsenceEntity> allAbsences,
  ) {
    return allAbsences.where((absence) {
      return !absence.startDate.isAfter(endDate) &&
          !absence.endDate.isBefore(startDate);
    }).toList();
  }
}
