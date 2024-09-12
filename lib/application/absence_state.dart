import 'package:absence_manager/domain/entities/entities.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'absence_state.freezed.dart';

@freezed
class AbsenceState with _$AbsenceState {
  // Initial state, before any data is loaded
  const factory AbsenceState.initial() = _Initial;

  // Loading state, data is being fetched
  const factory AbsenceState.loading(List<AbsenceEntity> absences) = _Loading;

  // Loaded state, absences have been successfully fetched and are displayed
  const factory AbsenceState.loaded({
    required List<AbsenceEntity> absences,
    required bool hasReachedMax, // True if there are no more absences to load
  }) = _Loaded;

  // Error state, an error occurred while loading absences
  const factory AbsenceState.error(String message) = _Error;

  // Empty state, no absences are available (or after filtering returns no results)
  const factory AbsenceState.empty() = _Empty;
}
