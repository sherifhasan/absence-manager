import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_entity.freezed.dart';


@freezed
class MemberEntity with _$MemberEntity {
  const factory MemberEntity({
    required int id,
    required int userId,
    required int crewId,
    required String name,
    required String image,
  }) = _MemberEntity;

}