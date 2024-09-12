import 'package:absence_manager/domain/app_repository.dart';
import 'package:absence_manager/domain/entities/entities.dart';
import 'package:absence_manager/infrastructure/datasource/data_source.dart';

import 'dto_models/dto_models.dart';

class AppRepositoryImp extends AppRepository {
  final DataSource _localDataSource;

  AppRepositoryImp(this._localDataSource);

  @override
  Future<List<AbsenceEntity>> absences() async {
    try {
      List<dynamic> absenceData = await _localDataSource.absences();

      // Ensure the data is not empty and is a valid list
      if (absenceData.isEmpty) {
        throw Exception('No absence data available.');
      }

      // Convert data to AbsenceEntity
      return absenceData
          .map((data) => AbsenceDto.fromJson(data).toEntity())
          .toList();
    } catch (error) {
      // Log the error or handle it accordingly
      throw Exception('Failed to load absences.');
    }
  }

  @override
  Future<Map<int, MemberEntity>> members() async {
    try {
      List<dynamic> membersData = await _localDataSource.members();

      // Ensure the data is not empty and is a valid list
      if (membersData.isEmpty) {
        throw Exception('No member data available.');
      }

      // Convert data to MemberEntity and return a map
      final membersList = membersData
          .map((data) => MemberDto.fromJson(data).toEntity())
          .toList();
      return {for (var member in membersList) member.userId: member};
    } catch (error) {
      // Log the error or handle it accordingly
      print('Error fetching members: $error');
      throw Exception('Failed to load members.');
    }
  }
}
