import 'package:flutter/foundation.dart';
import 'package:absence_manager/domain/app_repository.dart';
import 'package:absence_manager/domain/entities/entities.dart';
import 'package:absence_manager/data/datasource/data_source.dart';
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

      // Use compute to offload the JSON processing to a separate isolate
      return await compute(_parseAbsences, absenceData);
    } catch (error) {
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

      // Use compute to offload the JSON processing to a separate isolate
      return await compute(_parseMembers, membersData);
    } catch (error) {
      print('Error fetching members: $error');
      throw Exception('Failed to load members.');
    }
  }
}

// Separate function to parse absences in a background isolate
List<AbsenceEntity> _parseAbsences(List<dynamic> absenceData) {
  return absenceData
      .map((data) => AbsenceDto.fromJson(data).toEntity())
      .toList();
}

// Separate function to parse members in a background isolate
Map<int, MemberEntity> _parseMembers(List<dynamic> membersData) {
  final membersList =
      membersData.map((data) => MemberDto.fromJson(data).toEntity()).toList();
  return {for (var member in membersList) member.userId: member};
}
