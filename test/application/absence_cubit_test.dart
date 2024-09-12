import 'package:absence_manager/application/absence_cubit.dart';
import 'package:absence_manager/application/absence_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:absence_manager/domain/app_repository.dart';
import 'package:absence_manager/domain/entities/entities.dart';

// Mock class for AppRepository
class MockAppRepository extends Mock implements AppRepository {}

void main() {
  late AbsenceCubit absenceCubit;
  late MockAppRepository mockAppRepository;

  // Sample data for tests
  final absences = [
    AbsenceEntity(
      id: 1,
      crewId: 56,
      userId: 123,
      type: 'vacation',
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 10),
      createdAt: DateTime(2023, 11, 15),
    ),
    AbsenceEntity(
      id: 2,
      crewId: 56,
      memberNote: '',
      userId: 124,
      type: 'sickness',
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
    mockAppRepository = MockAppRepository();
    absenceCubit = AbsenceCubit(repository: mockAppRepository);

    // Reset the mock behavior before each test
    reset(mockAppRepository);
  });

  tearDown(() {
    absenceCubit.close();
  });

  group('AbsenceCubit', () {
    // Test: Initial Loading of Data
    blocTest<AbsenceCubit, AbsenceState>(
      'emits [loading, loaded] when data is loaded successfully',
      build: () {
        when(() => mockAppRepository.absences())
            .thenAnswer((_) async => absences);
        when(() => mockAppRepository.members())
            .thenAnswer((_) async => members);
        return absenceCubit;
      },
      act: (cubit) => cubit.loadInitialData(),
      expect: () => [
        const AbsenceState.loading([]),
        AbsenceState.loaded(
            absences: absences.take(2).toList(), hasReachedMax: true),
      ],
      verify: (_) {
        verify(() => mockAppRepository.absences()).called(1);
        verify(() => mockAppRepository.members()).called(1);
      },
    );

    // Test: Handling Empty State
    blocTest<AbsenceCubit, AbsenceState>(
      'emits [loading, empty] when no absences are available',
      build: () {
        when(() => mockAppRepository.absences()).thenAnswer((_) async => []);
        when(() => mockAppRepository.members())
            .thenAnswer((_) async => members);
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
      'emits [loading, error] when repository throws an error',
      build: () {
        when(() => mockAppRepository.absences())
            .thenThrow(Exception('Failed to load absences'));
        return absenceCubit;
      },
      act: (cubit) => cubit.loadInitialData(),
      expect: () => [
        const AbsenceState.loading([]),
        const AbsenceState.error(
            'Failed to load absences: Exception: Failed to load absences'),
      ],
    );
  });
}
