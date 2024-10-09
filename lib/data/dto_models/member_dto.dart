import 'package:absence_manager/domain/entities/entities.dart';
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

extension MemberDtoX on MemberDto {
  MemberEntity toEntity() {
    return MemberEntity(
      crewId: crewId,
      id: id,
      image: image,
      name: name,
      userId: userId,
    );
  }
}
