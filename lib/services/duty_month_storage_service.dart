import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/duty_month_model.dart';

class DutyMonthStorageService {
  static const String _storageKey = 'duty_months';

  Future<List<DutyMonth>> getMonths() async {
    final prefs = await SharedPreferences.getInstance();

    final String? storedData = prefs.getString(_storageKey);

    if (storedData == null || storedData.isEmpty) {
      return <DutyMonth>[];
    }

    try {
      final dynamic decoded = jsonDecode(storedData);

      if (decoded is! List) {
        return <DutyMonth>[];
      }

      final List<DutyMonth> months = [];

      for (final item in decoded) {
        if (item is Map) {
          final map = Map<String, dynamic>.from(item);

          months.add(
            DutyMonth.fromMap(map),
          );
        }
      }

      return months;
    } catch (e) {
      return <DutyMonth>[];
    }
  }

  Future<void> saveMonths(List<DutyMonth> months) async {
    final prefs = await SharedPreferences.getInstance();

    final List<Map<String, dynamic>> data = [];

    for (final month in months) {
      data.add(month.toMap());
    }

    await prefs.setString(
      _storageKey,
      jsonEncode(data),
    );
  }

  Future<bool> addMonth(DutyMonth month) async {
    final List<DutyMonth> months = await getMonths();

    final bool alreadyExists = months.any(
      (DutyMonth existingMonth) =>
          existingMonth.month == month.month &&
          existingMonth.year == month.year,
    );

    if (alreadyExists) {
      return false;
    }

    months.add(month);

    await saveMonths(months);

    return true;
  }

  Future<void> deleteMonth(String monthId) async {
    final List<DutyMonth> months = await getMonths();

    months.removeWhere(
      (DutyMonth month) => month.id == monthId,
    );

    await saveMonths(months);
  }

  Future<void> clearAllMonths() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_storageKey);
  }
}