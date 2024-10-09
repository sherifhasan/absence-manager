import 'package:absence_manager/domain/entities/entities.dart';
import 'package:absence_manager/domain/usecases/usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'absence_cubit.freezed.dart';

part 'absence_state.dart';

class AbsenceCubit extends Cubit<AbsenceState> {
  // Use cases for handling specific operations
  final LoadInitialDataUseCase _loadInitialDataUseCase;
  final LoadMoreAbsencesUseCase _loadMoreAbsencesUseCase;
  final FilterAbsencesByTypeUseCase _filterAbsencesByTypeUseCase;
  final FilterAbsencesByDateUseCase _filterAbsencesByDateUseCase;

  // The number of absences to load per page (pagination)
  final int perPage;

  // Add a public getter for allAbsences list
  List<AbsenceEntity> get allAbsences => _allAbsences;

  // Stores the entire list of absences
  final List<AbsenceEntity> _allAbsences = [];

  // Stores absences after filtering
  List<AbsenceEntity> _filteredAbsences = [];

  // Add a public getter for user map
  Map<int, MemberEntity> get userMap => _userMap;

  // Stores the map of users (members) indexed by userId
  final Map<int, MemberEntity> _userMap = {};

  // Keeps track of the current filter type applied (null if no filter)
  String? _currentFilterType;

  // Constructor initializes the use cases and sets the initial state
  AbsenceCubit({
    required LoadInitialDataUseCase loadInitialDataUseCase,
    required LoadMoreAbsencesUseCase loadMoreAbsencesUseCase,
    required FilterAbsencesByTypeUseCase filterAbsencesByTypeUseCase,
    required FilterAbsencesByDateUseCase filterAbsencesByDateUseCase,
    this.perPage = 10,
  })  : _loadInitialDataUseCase = loadInitialDataUseCase,
        _loadMoreAbsencesUseCase = loadMoreAbsencesUseCase,
        _filterAbsencesByTypeUseCase = filterAbsencesByTypeUseCase,
        _filterAbsencesByDateUseCase = filterAbsencesByDateUseCase,
        super(const AbsenceState.initial());

  // Loads the initial data, fetching absences and members from the repository
  Future<void> loadInitialData() async {
    emit(const AbsenceState.loading(
        [])); // Emit loading state with an empty list

    await Future.delayed(
        const Duration(seconds: 1)); // Simulate a delay to mimic loading time

    try {
      // Fetch absences and members from the repository using the use case
      final data = await _loadInitialDataUseCase();
      _allAbsences
          .addAll(data['absences']); // Store all absences in the cubit state
      _userMap.addAll(data['members']); // Store member data

      // If no absences are found, emit an empty state
      if (_allAbsences.isEmpty) {
        emit(const AbsenceState.empty());
      } else {
        // Only load the first batch of absences (perPage)
        loadAbsences();
      }
    } catch (e) {
      // If an error occurs, emit the error state with the message
      emit(AbsenceState.error('Failed to load absences: $e'));
    }
  }

  void loadAbsences() {
    _filteredAbsences.clear(); // Clear any previous filter
    _currentFilterType = null; // Reset the filter type

    // Fetch only the first batch of absences (limited by perPage)
    final initialAbsences = _allAbsences.take(perPage).toList();

    // Check if we have reached the max (i.e., loaded all absences)
    final hasReachedMax = initialAbsences.length == _allAbsences.length;

    // Emit the loaded state with absences and max flag
    emit(AbsenceState.loaded(
      absences: initialAbsences,
      hasReachedMax: hasReachedMax,
    ));
  }

// Loads more absences for pagination (when scrolling)
  Future<void> loadMoreAbsences() async {
    state.maybeWhen(
      loaded: (absences, hasReachedMax) async {
        if (hasReachedMax) {
          return; // Exit early if max absences have been loaded
        }

        emit(AbsenceState.loading(
            absences)); // Emit loading state with current absences

        await Future.delayed(const Duration(seconds: 1)); // Simulate a delay

        // Determine whether to paginate all absences or filtered ones
        final absencesToPaginate =
            _currentFilterType == null ? _allAbsences : _filteredAbsences;

        // Fetch the next set of absences
        final nextAbsences = _loadMoreAbsencesUseCase(
          allAbsences: absencesToPaginate,
          currentAbsences: absences,
        );

        // Check if the maximum has been reached
        final isMaxReached =
            absences.length + nextAbsences.length >= absencesToPaginate.length;

        // Emit the loaded state with the new batch of absences
        emit(AbsenceState.loaded(
          absences: absences + nextAbsences,
          hasReachedMax: isMaxReached,
        ));
      },
      orElse: () {}, // Do nothing if the state is not `loaded`
    );
  }

  // Filters absences by a given type (e.g., 'Vacation', 'Sickness')
  Future<void> filterAbsencesByType(String type) async {
    emit(const AbsenceState.loading([])); // Emit a loading state

    // Simulate a delay to mimic loading time
    await Future.delayed(const Duration(seconds: 1));

    // Filter absences using the provided type
    _filteredAbsences = _filterAbsencesByTypeUseCase(type, _allAbsences);
    _currentFilterType = type; // Store the current filter type

    // Emit an empty state if no absences match the filter
    if (_filteredAbsences.isEmpty) {
      emit(const AbsenceState.empty());
    } else {
      // Otherwise, emit the filtered absences with pagination support
      final initialFilteredAbsences = _filteredAbsences.take(perPage).toList();
      emit(AbsenceState.loaded(
        absences: initialFilteredAbsences,
        hasReachedMax:
            initialFilteredAbsences.length == _filteredAbsences.length,
      ));
    }
  }

  // Filters absences based on a date range (start and end dates)
  Future<void> filterAbsencesByDate(
      DateTime startDate, DateTime endDate) async {
    emit(const AbsenceState.loading([])); // Emit a loading state

    // Simulate a delay to mimic loading time
    await Future.delayed(const Duration(seconds: 1));

    // Filter absences by the given date range
    _filteredAbsences =
        _filterAbsencesByDateUseCase(startDate, endDate, _allAbsences);

    // Set a special filter type for date filtering
    _currentFilterType = 'date';

    // Emit an empty state if no absences fall within the date range
    if (_filteredAbsences.isEmpty) {
      emit(const AbsenceState.empty());
    } else {
      // Otherwise, emit the filtered absences with pagination support
      final initialFilteredAbsences = _filteredAbsences.take(perPage).toList();
      emit(AbsenceState.loaded(
        absences: initialFilteredAbsences,
        hasReachedMax:
            initialFilteredAbsences.length == _filteredAbsences.length,
      ));
    }
  }
}
