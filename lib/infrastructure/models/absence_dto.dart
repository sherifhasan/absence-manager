import 'package:freezed_annotation/freezed_annotation.dart';

part 'absence_dto.freezed.dart';

part 'absence_dto.g.dart';

@freezed
class AbsenceDto with _$AbsenceDto {
  const factory AbsenceDto({
    required final int crewId,
    required final DateTime endDate,
    required final int id,
    required final String memberNote,
    required final String type,
    required final int userId,
    required final String admitterNote,
    required final String createdAt,
    required final String startDate,
    final int? admitterId,
    final String? confirmedAt,
    final String? rejectedAt,
  }) = _AbsenceDto;

  factory AbsenceDto.fromJson(Map<String, dynamic> json) =>
      _$AbsenceDtoFromJson(json);
}
