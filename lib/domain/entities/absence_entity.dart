import 'package:freezed_annotation/freezed_annotation.dart';

part 'absence_entity.freezed.dart';

@freezed
class AbsenceEntity with _$AbsenceEntity {
  const factory AbsenceEntity({
    required final int crewId,
    required final DateTime endDate,
    required final int id,
    required final String memberNote,
    required final String type,
    required final int userId,
    required final String admitterNote,
    required final DateTime createdAt,
    required final DateTime startDate,
    final int? admitterId,
    final DateTime? confirmedAt,
    final DateTime? rejectedAt,
  }) = _AbsenceEntity;
}
