import 'package:absence_manager/application/absence_cubit.dart';
import 'package:absence_manager/domain/entities/entities.dart';
import 'package:absence_manager/domain/usecases/usecases.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes for use cases
class MockLoadInitialDataUseCase extends Mock
    implements LoadInitialDataUseCase {}

class MockLoadMoreAbsencesUseCase extends Mock
    implements LoadMoreAbsencesUseCase {}

class MockFilterAbsencesByTypeUseCase extends Mock
    implements FilterAbsencesByTypeUseCase {}

class MockFilterAbsencesByDateUseCase extends Mock
    implements FilterAbsencesByDateUseCase {}

void main() {
  late AbsenceCubit absenceCubit;
  late MockLoadInitialDataUseCase mockLoadInitialDataUseCase;
  late MockLoadMoreAbsencesUseCase mockLoadMoreAbsencesUseCase;
  late MockFilterAbsencesByTypeUseCase mockFilterAbsencesByTypeUseCase;
  late MockFilterAbsencesByDateUseCase mockFilterAbsencesByDateUseCase;

  // Sample data for tests
  final absences = [
    AbsenceEntity(
      id: 1,
      crewId: 56,
      userId: 123,
      type: 'vacation',
      status: 'Requested',
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 10),
      createdAt: DateTime(2023, 11, 15),
    ),
    AbsenceEntity(
      id: 2,
      crewId: 56,
      memberNote: 'Sorry',
      userId: 124,
      type: 'sickness',
      status: 'Confirmed',
      startDate: DateTime(2024, 2, 2),
      endDate: DateTime(2024, 2, 5),
      createdAt: DateTime(2024, 2, 1),
    ),
  ];

  final members = {
    1: const MemberEntity(
        id: 1, name: 'John Doe', userId: 123, crewId: 56, image: ''),
    2: const MemberEntity(
        id: 2, name: 'Jane Smith', userId: 124, crewId: 56, image: ''),
  };

  setUp(() {
    mockLoadInitialDataUseCase = MockLoadInitialDataUseCase();
    mockLoadMoreAbsencesUseCase = MockLoadMoreAbsencesUseCase();
    mockFilterAbsencesByTypeUseCase = MockFilterAbsencesByTypeUseCase();
    mockFilterAbsencesByDateUseCase = MockFilterAbsencesByDateUseCase();

    // Inject mocks into the AbsenceCubit
    absenceCubit = AbsenceCubit(
      loadInitialDataUseCase: mockLoadInitialDataUseCase,
      loadMoreAbsencesUseCase: mockLoadMoreAbsencesUseCase,
      filterAbsencesByTypeUseCase: mockFilterAbsencesByTypeUseCase,
      filterAbsencesByDateUseCase: mockFilterAbsencesByDateUseCase,
      perPage: 1,
    );
  });

  tearDown(() {
    absenceCubit.close();
  });

  group('AbsenceCubit', () {
    // Test: Initial Loading of Data
    blocTest<AbsenceCubit, AbsenceState>(
      'emits [loading, loaded] when data is loaded successfully',
      build: () {
        when(() => mockLoadInitialDataUseCase()).thenAnswer((_) async => {
              'absences': absences,
              'members': members,
            });
        return absenceCubit;
      },
      act: (cubit) => cubit.loadInitialData(),
      expect: () => [
        const AbsenceState.loading([]),
        AbsenceState.loaded(
            absences: absences.take(1).toList(), hasReachedMax: false),
      ],
      verify: (_) => verify(() => mockLoadInitialDataUseCase()).called(1),
    );

    // Test: Loading More Absences
    blocTest<AbsenceCubit, AbsenceState>(
      'emits [loading, loaded] with more absences when loadMoreAbsences is called',
      build: () {
        when(() => mockLoadInitialDataUseCase()).thenAnswer((_) async => {
              'absences': absences,
              'members': members,
            });

        when(() => mockLoadMoreAbsencesUseCase(
              allAbsences: absences,
              currentAbsences: absences.take(1).toList(),
            )).thenReturn(absences.skip(1).toList());

        return absenceCubit;
      },
      act: (cubit) async {
        await cubit.loadInitialData();
        await cubit.loadMoreAbsences();
      },
      wait: const Duration(seconds: 1),
      expect: () => [
        const AbsenceState.loading([]),
        AbsenceState.loaded(
            absences: absences.take(1).toList(), hasReachedMax: false),
        AbsenceState.loading(absences.take(1).toList()),
        AbsenceState.loaded(absences: absences, hasReachedMax: true),
      ],
      verify: (_) {
        verify(() => mockLoadInitialDataUseCase()).called(1);
        verify(() => mockLoadMoreAbsencesUseCase(
              allAbsences: absences,
              currentAbsences: absences.take(1).toList(),
            )).called(1);
      },
    );

    // Test: Filtering Absences by Type (vacation)
    blocTest<AbsenceCubit, AbsenceState>(
      'emits [loading, loaded] when absences are filtered by type',
      build: () {
        when(() => mockLoadInitialDataUseCase()).thenAnswer((_) async => {
              'absences': absences,
              'members': members,
            });
        when(() => mockFilterAbsencesByTypeUseCase('vacation', absences))
            .thenReturn([absences.first]);
        return absenceCubit;
      },
      act: (cubit) async {
        await cubit.loadInitialData();
        await cubit.filterAbsencesByType('vacation');
      },
      expect: () => [
        const AbsenceState.loading([]),
        AbsenceState.loaded(
            absences: absences.take(1).toList(), hasReachedMax: false),
        const AbsenceState.loading([]),
        AbsenceState.loaded(absences: [absences.first], hasReachedMax: true),
      ],
      verify: (_) {
        verify(() => mockLoadInitialDataUseCase()).called(1);
        verify(() => mockFilterAbsencesByTypeUseCase('vacation', absences))
            .called(1);
      },
    );

    // Test: Filtering Absences by Date
    blocTest<AbsenceCubit, AbsenceState>(
      'emits [loading, loaded] when absences are filtered by date',
      build: () {
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 10);

        when(() => mockLoadInitialDataUseCase()).thenAnswer((_) async => {
              'absences': absences,
              'members': members,
            });

        when(() =>
                mockFilterAbsencesByDateUseCase(startDate, endDate, absences))
            .thenReturn([absences.first]);

        return absenceCubit;
      },
      act: (cubit) async {
        await cubit.loadInitialData();
        await cubit.filterAbsencesByDate(
            DateTime(2024, 1, 1), DateTime(2024, 1, 10));
      },
      expect: () => [
        const AbsenceState.loading([]),
        AbsenceState.loaded(
            absences: absences.take(1).toList(), hasReachedMax: false),
        const AbsenceState.loading([]),
        AbsenceState.loaded(absences: [absences.first], hasReachedMax: true),
      ],
      verify: (_) {
        verify(() => mockLoadInitialDataUseCase()).called(1);
        verify(() => mockFilterAbsencesByDateUseCase(
            DateTime(2024, 1, 1), DateTime(2024, 1, 10), absences)).called(1);
      },
    );

    // Test: Handling Empty State
    blocTest<AbsenceCubit, AbsenceState>(
      'emits [loading, empty] when no absences are available',
      build: () {
        when(() => mockLoadInitialDataUseCase()).thenAnswer((_) async => {
              'absences': <AbsenceEntity>[],
              'members': members,
            });
        return absenceCubit;
      },
      act: (cubit) => cubit.loadInitialData(),
      expect: () => [
        const AbsenceState.loading([]),
        const AbsenceState.empty(),
      ],
    );

    // Test: Handling Error State
    blocTest<AbsenceCubit, AbsenceState>(
      'emits [loading, error] when an error occurs',
      build: () {
        when(() => mockLoadInitialDataUseCase())
            .thenThrow(Exception('Failed to load data'));
        return absenceCubit;
      },
      act: (cubit) => cubit.loadInitialData(),
      expect: () => [
        const AbsenceState.loading([]),
        const AbsenceState.error(
            'Failed to load absences: Exception: Failed to load data'),
      ],
    );
  });
}
