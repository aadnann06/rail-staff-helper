import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/monthly_duty_model.dart';

class MonthlyDutyStorageService {
  static const String _storageKey = 'monthly_duties';

  Future<List<MonthlyDuty>> getDuties() async {
    final prefs = await SharedPreferences.getInstance();

    final String? storedData = prefs.getString(_storageKey);

    if (storedData == null || storedData.isEmpty) {
      return <MonthlyDuty>[];
    }

    try {
      final dynamic decoded = jsonDecode(storedData);

      if (decoded is! List) {
        return <MonthlyDuty>[];
      }

      final List<MonthlyDuty> duties = [];

      for (final item in decoded) {
        if (item is Map) {
          final map = Map<String, dynamic>.from(item);

          duties.add(
            MonthlyDuty.fromMap(map),
          );
        }
      }
      

      return duties;
    } catch (e) {
      return <MonthlyDuty>[];
    }
  }
  Future<List<MonthlyDuty>> getDutiesForMonth(String monthId) async {
  final List<MonthlyDuty> duties = await getDuties();

  return duties.where(
    (MonthlyDuty duty) => duty.monthId == monthId,
  ).toList();
}

  Future<void> saveDuties(List<MonthlyDuty> duties) async {
    final prefs = await SharedPreferences.getInstance();

    final List<Map<String, dynamic>> data = [];

    for (final duty in duties) {
      data.add(duty.toMap());
    }

    await prefs.setString(
      _storageKey,
      jsonEncode(data),
    );
  }

  Future<void> addDuty(MonthlyDuty duty) async {
    final List<MonthlyDuty> duties = await getDuties();

    duties.add(duty);

    await saveDuties(duties);
  }

  Future<void> updateDuty(MonthlyDuty updatedDuty) async {
    final List<MonthlyDuty> duties = await getDuties();

    final int index = duties.indexWhere(
      (MonthlyDuty duty) => duty.id == updatedDuty.id,
    );

    if (index == -1) {
      return;
    }

    duties[index] = updatedDuty;

    await saveDuties(duties);
  }

  Future<void> deleteDuty(String dutyId) async {
    final List<MonthlyDuty> duties = await getDuties();

    duties.removeWhere(
      (MonthlyDuty duty) => duty.id == dutyId,
    );

    await saveDuties(duties);
  }

  Future<void> clearAllDuties() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_storageKey);
  }
}