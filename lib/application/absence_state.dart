part of 'absence_cubit.dart';


@freezed
class AbsenceState with _$AbsenceState {
  // Initial state, before any data is loaded
  const factory AbsenceState.initial() = Initial;

  // Loading state, data is being fetched
  const factory AbsenceState.loading(List<AbsenceEntity> absences) = _Loading;

  // Loaded state, absences have been successfully fetched and are displayed
  const factory AbsenceState.loaded({
    required List<AbsenceEntity> absences,
    required bool hasReachedMax, // True if there are no more absences to load
  }) = Loaded;

  // Error state, an error occurred while loading absences
  const factory AbsenceState.error(String message) = Error;

  // Empty state, no absences are available (or after filtering returns no results)
  const factory AbsenceState.empty() = Empty;
}
