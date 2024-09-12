import 'package:absence_manager/domain/app_repository.dart';
import 'package:absence_manager/domain/entities/entities.dart';
import 'package:absence_manager/infrastructure/datasource/data_source.dart';

import 'dto_models/dto_models.dart';

class AppRepositoryImp extends AppRepository {
  final DataSource _localDataSource;

  AppRepositoryImp(this._localDataSource);

  @override
  Future<List<AbsenceEntity>> absences() async {
    List<dynamic> absenceData = await _localDataSource.absences();
    return absenceData
        .map((data) => AbsenceDto.fromJson(data).toEntity())
        .toList();
  }

  @override
  Future<Map<int, MemberEntity>> members() async {
    List<dynamic> membersData = await _localDataSource.members();
    final membersList =
        membersData.map((data) => MemberDto.fromJson(data).toEntity()).toList();
    return {for (var member in membersList) member.userId: member};
  }
}
