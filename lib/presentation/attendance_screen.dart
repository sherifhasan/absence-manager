import 'package:absence_manager/application/absence_cubit.dart';
import 'package:absence_manager/application/absence_state.dart';
import 'package:absence_manager/presentation/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AttendanceScreen extends HookWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the AbsenceCubit instance from the context
    final absenceCubit = context.read<AbsenceCubit>();

    // Date state management using useState from flutter_hooks
    final selectedStartDate = useState<DateTime?>(null);
    final selectedEndDate = useState<DateTime?>(null);

    // Function to filter absences by date
    void filterByDate() async {
      final startDate = await _selectDate(
          initialDate: selectedStartDate.value ?? DateTime.now(),
          label: 'Select Start Date');
      if (startDate != null) {
        final endDate = await _selectDate(
            initialDate: selectedEndDate.value ?? startDate,
            label: 'Select End Date');
        if (endDate != null) {
          absenceCubit.filterAbsencesByDate(startDate, endDate);
          selectedStartDate.value = startDate;
          selectedEndDate.value = endDate;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: BlocBuilder<AbsenceCubit, AbsenceState>(
        builder: (context, state) {
          return Column(
            children: [
              if (absenceCubit.allAbsences.isNotEmpty)
                Column(
                  children: [
                    // Total Absences
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Total absences in system: ${absenceCubit.allAbsences.length}'),
                    ),

                    // Filter Options
                    FilterOptions(
                        absenceCubit: absenceCubit, filterByDate: filterByDate),
                  ],
                ),
              state.when(
                initial: () => const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                loading: (absences) =>
                    AbsenceList(absences: absences, isLoading: true),
                loaded: (absences, hasReachedMax) => AbsenceList(
                    absences: absences,
                    isLoading: false,
                    hasReachedMax: hasReachedMax),
                empty: () => const Expanded(
                  child: Center(
                    child: Text('No absences to display'),
                  ),
                ),
                error: (message) => Expanded(
                  child: Center(
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

  Future<DateTime?> _selectDate(
      {required DateTime initialDate, required String label}) async {
    return await showDatePicker(
      context: useContext(),
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: label,
    );
  }
}
