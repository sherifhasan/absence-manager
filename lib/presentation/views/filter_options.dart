import 'package:flutter/material.dart';

class FilterOptions extends StatelessWidget {
  final VoidCallback filterByDate;
  final void Function(String) filterByAbsencesByType;
  final VoidCallback loadAllAbsences;

  const FilterOptions(
      {required this.filterByDate,
      required this.filterByAbsencesByType,
      required this.loadAllAbsences,
      super.key});

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
              onPressed: loadAllAbsences,
              child: const Text('All'),
            ),
            ElevatedButton(
              onPressed: () => filterByAbsencesByType('vacation'),
              child: const Text('Filter by Vacation'),
            ),
            ElevatedButton(
              onPressed: () => filterByAbsencesByType('sickness'),
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
