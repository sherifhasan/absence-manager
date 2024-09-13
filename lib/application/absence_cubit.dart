import 'package:absence_manager/domain/app_repository.dart';
import 'package:absence_manager/domain/entities/entities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'absence_cubit.freezed.dart';

part 'absence_state.dart';

class AbsenceCubit extends Cubit<AbsenceState> {
  final AppRepository _repository;
  final int perPage;

  // Store all absences
  final List<AbsenceEntity> _allAbsences = [];
  List<AbsenceEntity> _filteredAbsences = [];

  // Add a public getter for allAbsences list
  List<AbsenceEntity> get allAbsences => _allAbsences;

  // Assuming you have a private variable _userMap
  final Map<int, MemberEntity> _userMap = {};

  // Add a public getter for user map
  Map<int, MemberEntity> get userMap => _userMap;

  // Store the type of filter applied
  String? _currentFilterType;

  AbsenceCubit({required AppRepository repository, this.perPage = 10})
      : _repository = repository,
        super(const AbsenceState.initial());

  Future<void> loadInitialData() async {
    emit(const AbsenceState.loading([]));

    // Simulate a 2-second delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Fetch absences and members after delay
      _allAbsences.addAll(await _repository.absences());
      _userMap.addAll(await _repository.members());

      if (allAbsences.isEmpty) {
        emit(const AbsenceState.empty());
      } else {
        loadAbsences();
      }
    } catch (e) {
      emit(AbsenceState.error('Failed to load absences: $e'));
    }
  }

  void loadAbsences() {
    _filteredAbsences.clear(); // Reset filtered absences
    _currentFilterType = null; // Reset current filter type
    final initialAbsences = allAbsences.take(perPage).toList();
    emit(AbsenceState.loaded(
      absences: initialAbsences,
      hasReachedMax: initialAbsences.length == allAbsences.length,
    ));
  }

  void loadMoreAbsences() async {
    state.maybeWhen(
      loaded: (absences, hasReachedMax) async {
        if (hasReachedMax) return;

        emit(AbsenceState.loading(absences));

        await Future.delayed(const Duration(seconds: 2));

        // Determine which list to paginate: filtered or all absences
        final absencesToPaginate =
            _currentFilterType == null ? _allAbsences : _filteredAbsences;

        final nextAbsences =
            absencesToPaginate.skip(absences.length).take(perPage).toList();

        if (nextAbsences.isEmpty) {
          emit(AbsenceState.loaded(
            absences: absences,
            hasReachedMax: true,
          ));
        } else {
          emit(AbsenceState.loaded(
            absences: absences + nextAbsences,
            hasReachedMax: absences.length + nextAbsences.length >=
                absencesToPaginate.length,
          ));
        }
      },
      orElse: () {},
    );
  }

  Future<void> filterAbsencesByType(String type) async {
    emit(const AbsenceState.loading([]));
    await Future.delayed(const Duration(seconds: 2)); // Simulate delay

    // Apply filter and store the filtered absences
    _filteredAbsences = _allAbsences
        .where((absence) => absence.type.toLowerCase() == type.toLowerCase())
        .toList();
    _currentFilterType = type; // Set the current filter type

    if (_filteredAbsences.isEmpty) {
      emit(const AbsenceState.empty());
    } else {
      // Load the first page of filtered absences
      final initialFilteredAbsences = _filteredAbsences.take(perPage).toList();
      emit(AbsenceState.loaded(
        absences: initialFilteredAbsences,
        hasReachedMax:
            initialFilteredAbsences.length == _filteredAbsences.length,
      ));
    }
  }

  Future<void> filterAbsencesByDate(
      DateTime startDate, DateTime endDate) async {
    emit(const AbsenceState.loading([]));
    await Future.delayed(const Duration(seconds: 2)); // Simulate delay

    // Filter absences by date
    _filteredAbsences = allAbsences.where((absence) {
      return !absence.startDate.isAfter(endDate) &&
          !absence.endDate.isBefore(startDate);
    }).toList();

    _currentFilterType = 'date'; // Set a special filter type for date

    if (_filteredAbsences.isEmpty) {
      emit(const AbsenceState.empty());
    } else {
      final initialFilteredAbsences = _filteredAbsences.take(perPage).toList();
      emit(AbsenceState.loaded(
        absences: initialFilteredAbsences,
        hasReachedMax:
            initialFilteredAbsences.length == _filteredAbsences.length,
      ));
    }
  }
}
