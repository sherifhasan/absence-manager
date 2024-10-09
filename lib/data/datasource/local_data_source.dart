import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'package:absence_manager/data/datasource/data_source.dart';

class LocalDataSource extends DataSource {
  final absencesPath = 'assets/json_files/absences.json';
  final membersPath = 'assets/json_files/members.json';

  Future<List<dynamic>> readJsonFile(String path) async {
    try {
      String content = await rootBundle.loadString(path);
      Map<String, dynamic> data = jsonDecode(content);
      if (data.containsKey('payload')) {
        return data['payload'];
      } else {
        throw Exception('Payload key not found in JSON.');
      }
    } catch (e) {
      throw Exception('Error reading JSON file at $path: $e');
    }
  }

  @override
  Future<List<dynamic>> absences() async {
    return readJsonFile(absencesPath);
  }

  @override
  Future<List<dynamic>> members() async {
    return readJsonFile(membersPath);
  }
}
