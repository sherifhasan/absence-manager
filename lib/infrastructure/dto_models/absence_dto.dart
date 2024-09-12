import 'package:absence_manager/domain/entities/absence_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'absence_dto.freezed.dart';

part 'absence_dto.g.dart';

@freezed
class AbsenceDto with _$AbsenceDto {
  const factory AbsenceDto({
    required final int crewId,
    required final DateTime endDate,
    required final int id,
    required final String type,
    required final int userId,
    required final DateTime createdAt,
    required final DateTime startDate,
    final String? admitterNote,
    final int? admitterId,
    final String? memberNote,
    final DateTime? confirmedAt,
    final DateTime? rejectedAt,
  }) = _AbsenceDto;

  factory AbsenceDto.fromJson(Map<String, dynamic> json) =>
      _$AbsenceDtoFromJson(json);
}

extension AbsenceX on AbsenceDto {
  AbsenceEntity toEntity() {
    return AbsenceEntity(
        createdAt: createdAt,
        confirmedAt: confirmedAt,
        rejectedAt: rejectedAt,
        crewId: crewId,
        endDate: endDate,
        id: id,
        startDate: startDate,
        type: type,
        admitterNote: admitterNote,
        memberNote: memberNote,
        userId: userId);
  }
}
