import 'package:absence_manager/application/absence_cubit.dart';
import 'package:absence_manager/presentation/views/absence_list.dart';
import 'package:absence_manager/presentation/views/filter_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AttendanceScreen extends HookWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedStartDate = useState<DateTime?>(null);
    final selectedEndDate = useState<DateTime?>(null);
    final selectedFilter = useState<String>('all');

    final absenceCubit = context.read<AbsenceCubit>();

    Future<void> filterByDate() async {
      try {
        final startDate = await selectDate(
          context,
          initialDate: selectedStartDate.value ?? DateTime.now(),
          label: 'Select Start Date',
        );
        if (!context.mounted) return;

        if (startDate != null) {
          final endDate = await selectDate(
            context,
            initialDate: selectedEndDate.value ?? startDate,
            label: 'Select End Date',
          );
          if (!context.mounted) return;

          // Validate that the endDate is not before the startDate
          if (endDate != null && endDate.isBefore(startDate)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text('End Date cannot be before Start Date.'),
              ),
            );
            return;
          }

          if (endDate != null) {
            selectedStartDate.value = startDate;
            selectedEndDate.value = endDate;
            selectedFilter.value = 'date';
            absenceCubit.filterAbsencesByDate(startDate, endDate);
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text('Error selecting dates: $e')),
        );
      }
    }

    void loadAllAbsences() {
      selectedFilter.value = 'all';
      selectedStartDate.value = null;
      selectedEndDate.value = null;
      absenceCubit.loadAbsences();
    }

    void filterByAbsencesByType(String type) {
      selectedFilter.value = type;
      selectedStartDate.value = null;
      selectedEndDate.value = null;
      absenceCubit.filterAbsencesByType(type);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: BlocBuilder<AbsenceCubit, AbsenceState>(
        builder: (context, state) {
          final totalAbsencesInSystem = absenceCubit.allAbsences.length;

          return Column(
            children: [
              // Display total absences in the system
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total absences in system: $totalAbsencesInSystem',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              // Filter Options (Always Visible)
              FilterOptions(
                filterByDate: filterByDate,
                loadAllAbsences: loadAllAbsences,
                filterByAbsencesByType: filterByAbsencesByType,
                selectedFilter: selectedFilter.value,
              ),

              // Conditionally show the absence list or a message
              Expanded(
                child: state.when(
                  initial: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  loading: (absences) => AbsenceList(
                    absences: absences,
                    isLoading: true,
                  ),
                  loaded: (absences, hasReachedMax) => AbsenceList(
                    absences: absences,
                    isLoading: false,
                    hasReachedMax: hasReachedMax,
                  ),
                  empty: () => const Center(
                    child: Text('No absences to display'),
                  ),
                  error: (message) => Center(
                    child: Text('Error: $message'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<DateTime?> selectDate(
    BuildContext context, {
    required DateTime initialDate,
    required String label,
  }) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: label,
    );
  }
}
