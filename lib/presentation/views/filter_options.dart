import 'package:absence_manager/application/absence_cubit.dart';
import 'package:flutter/material.dart';

class FilterOptions extends StatelessWidget {
  final AbsenceCubit absenceCubit;
  final VoidCallback filterByDate;

  const FilterOptions(
      {required this.absenceCubit, required this.filterByDate, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                absenceCubit.loadAbsences();
              },
              child: const Text('All'),
            ),
            ElevatedButton(
              onPressed: () {
                absenceCubit.filterAbsencesByType('vacation');
              },
              child: const Text('Filter by Vacation'),
            ),
            ElevatedButton(
              onPressed: () {
                absenceCubit.filterAbsencesByType('sickness');
              },
              child: const Text('Filter by Sickness'),
            ),
            ElevatedButton(
              onPressed: filterByDate,
              child: const Text('Filter by Date'),
            ),
          ],
        ),
      ),
    );
  }
}
