import 'package:absence_manager/domain/entities/entities.dart';

class LoadMoreAbsencesUseCase {
  final int perPage;

  LoadMoreAbsencesUseCase({this.perPage = 10});

  List<AbsenceEntity> call({
    required List<AbsenceEntity> allAbsences,
    required List<AbsenceEntity> currentAbsences,
  }) {
    final nextAbsences =
        allAbsences.skip(currentAbsences.length).take(perPage).toList();

    return nextAbsences;
  }
}
