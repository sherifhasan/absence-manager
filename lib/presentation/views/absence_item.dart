import 'package:absence_manager/domain/entities/absence_entity.dart';
import 'package:absence_manager/domain/entities/member_entity.dart';
import 'package:absence_manager/presentation/utils.dart';
import 'package:flutter/material.dart';

class AbsenceItem extends StatelessWidget {
  final MemberEntity? member;
  final AbsenceEntity absence;

  const AbsenceItem({super.key, required this.member, required this.absence});

  @override
  Widget build(BuildContext context) {
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
                'Period: ${absence.startDate.formatDateString()} - ${absence.endDate.formatDateString()}',
              ),
              if (absence.memberNote != null && absence.memberNote!.isNotEmpty)
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
  }
}
