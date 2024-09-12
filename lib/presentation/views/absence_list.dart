import 'package:absence_manager/application/absence_cubit.dart';
import 'package:absence_manager/presentation/utils.dart';
import 'package:flutter/material.dart';
import 'package:absence_manager/domain/entities/entities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AbsenceList extends HookWidget {
  final List<AbsenceEntity> absences;
  final bool isLoading;
  final bool hasReachedMax;

  const AbsenceList({
    super.key,
    required this.absences,
    required this.isLoading,
    this.hasReachedMax = false,
  });

  @override
  Widget build(BuildContext context) {
    // ScrollController using flutter_hooks
    final scrollController = useScrollController();

    // Add a listener for scroll to detect when we reach the end
    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          context.read<AbsenceCubit>().loadMoreAbsences();
        }
      });
      return () => scrollController.dispose();
    }, [scrollController]);

    return Expanded(
      child: ListView.builder(
        controller: scrollController, // Use ScrollController
        itemCount: absences.length + (isLoading || !hasReachedMax ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= absences.length) {
            if (hasReachedMax) {
              return const Center(child: Text('No more absences'));
            }
            return const Center(
                child: CircularProgressIndicator()); // Show loading spinner
          }
          final absence = absences[index];
          final member =
              context.read<AbsenceCubit>().userMap[absence.userId];

          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: Card(
              child: ListTile(
                title: Text(
                  member?.name ?? 'Unknown',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(absence.type),
                    Text(
                        'Period: ${absence.startDate.formatDateString()} - ${absence.endDate.formatDateString()}'),
                    if (absence.memberNote != null &&
                        absence.memberNote!.isNotEmpty)
                      Text('Member Note: ${absence.memberNote}'),
                    Text('Status: ${absence.status}'),
                    if (absence.admitterNote != null &&
                        absence.admitterNote!.isNotEmpty)
                      Text('Admitter Note: ${absence.admitterNote}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
