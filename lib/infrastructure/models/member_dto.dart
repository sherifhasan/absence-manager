import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_dto.freezed.dart';

part 'member_dto.g.dart';

@freezed
class MemberDto with _$MemberDto {
  const factory MemberDto({
    required int id,
    required int userId,
    required int crewId,
    required String name,
    required String image,
  }) = _MemberDto;

  factory MemberDto.fromJson(Map<String, dynamic> json) =>
      _$MemberDtoFromJson(json);
}
