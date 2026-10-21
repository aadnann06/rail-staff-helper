import 'package:shared_preferences/shared_preferences.dart';

class EmployeeStorageService {
  static const String nameKey = 'employee_name';
  static const String employeeIdKey = 'employee_id';
  static const String staffCategoryKey = 'staff_category';
  static const String designationKey = 'designation';
  static const String payLevelKey = 'pay_level';
  static const String departmentKey = 'department';
  static const String zoneKey = 'railway_zone';
  static const String hqKey = 'headquarters';
  static const String mobileKey = 'mobile';

  Future<void> saveProfile({
    required String name,
    required String employeeId,
    required String staffCategory,
    required String designation,
    required String payLevel,
    required String department,
    required String zone,
    required String hq,
    required String mobile,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(nameKey, name);
    await prefs.setString(employeeIdKey, employeeId);
    await prefs.setString(staffCategoryKey, staffCategory);
    await prefs.setString(designationKey, designation);
    await prefs.setString(payLevelKey, payLevel);
    await prefs.setString(departmentKey, department);
    await prefs.setString(zoneKey, zone);
    await prefs.setString(hqKey, hq);
    await prefs.setString(mobileKey, mobile);
  }

  Future<Map<String, String>> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      nameKey: prefs.getString(nameKey) ?? '',
      employeeIdKey: prefs.getString(employeeIdKey) ?? '',
      staffCategoryKey: prefs.getString(staffCategoryKey) ?? '',
      designationKey: prefs.getString(designationKey) ?? '',
      payLevelKey: prefs.getString(payLevelKey) ?? '',
      departmentKey: prefs.getString(departmentKey) ?? '',
      zoneKey: prefs.getString(zoneKey) ?? '',
      hqKey: prefs.getString(hqKey) ?? '',
      mobileKey: prefs.getString(mobileKey) ?? '',
    };
  }
}