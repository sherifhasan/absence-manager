import 'package:absence_manager/domain/app_repository.dart';
import 'package:absence_manager/domain/entities/entities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'absence_state.dart';

class AbsenceCubit extends Cubit<AbsenceState> {
  final AppRepository _repository;
  final int perPage;

  List<AbsenceEntity> allAbsences = [];
  Map<int, MemberEntity> userMap = {};

  AbsenceCubit({required AppRepository repository, this.perPage = 10})
      : _repository = repository,
        super(const AbsenceState.initial());

  Future<void> loadInitialData() async {
    emit(const AbsenceState.loading([]));

    try {
      allAbsences = await _repository.absences();
      userMap = await _repository.members();

      if (allAbsences.isEmpty) {
        emit(const AbsenceState.empty());
      } else {
        final initialAbsences = allAbsences.take(perPage).toList();
        emit(AbsenceState.loaded(
            absences: initialAbsences,
            hasReachedMax: initialAbsences.length == allAbsences.length));
      }
    } catch (e) {
      emit(AbsenceState.error('Failed to load absences: $e'));
    }
  }

  void loadMoreAbsences() async {
    state.maybeWhen(
      loaded: (absences, hasReachedMax) async {
        if (!hasReachedMax) {
          emit(AbsenceState.loading(absences));

          await Future.delayed(const Duration(seconds: 1)); // Simulate delay

          // Load the next batch of absences
          final nextAbsences =
              allAbsences.skip(absences.length).take(perPage).toList();

          // Check if there are no more absences to load
          if (nextAbsences.isEmpty) {
            emit(
              AbsenceState.loaded(absences: absences, hasReachedMax: true),
            ); // hasReachedMax = true
          } else {
            emit(
              AbsenceState.loaded(
                  absences: absences + nextAbsences, hasReachedMax: false),
            ); // Add new absences
          }
        }
      },
      orElse: () => null, // Do nothing if it's not in the loaded state
    );
  }

  void filterAbsencesByType(String type) {
    emit(const AbsenceState.loading([]));

    final filteredAbsences =
        allAbsences.where((absence) => absence.type == type).toList();

    if (filteredAbsences.isEmpty) {
      emit(const AbsenceState.empty());
    } else {
      emit(
          AbsenceState.loaded(absences: filteredAbsences, hasReachedMax: true));
    }
  }

  void filterAbsencesByDate(DateTime startDate, DateTime endDate) {
    emit(const AbsenceState.loading([]));

    final filteredAbsences = allAbsences.where((absence) {
      final absenceStart = absence.startDate;
      final absenceEnd = absence.endDate;
      return (absenceStart.isAfter(startDate) ||
              absenceStart.isAtSameMomentAs(startDate)) &&
          (absenceEnd.isBefore(endDate) ||
              absenceEnd.isAtSameMomentAs(endDate));
    }).toList();

    if (filteredAbsences.isEmpty) {
      emit(const AbsenceState.empty());
    } else {
      emit(
          AbsenceState.loaded(absences: filteredAbsences, hasReachedMax: true));
    }
  }
}
