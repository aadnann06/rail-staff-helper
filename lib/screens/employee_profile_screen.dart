import 'package:flutter/material.dart';
import '../services/employee_storage_service.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({super.key});

  @override
  State<EmployeeProfileScreen> createState() =>
      _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState
    extends State<EmployeeProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final EmployeeStorageService _storageService =
    EmployeeStorageService();

  final nameController = TextEditingController();
  final employeeIdController = TextEditingController();
  final departmentController = TextEditingController();
  final zoneController = TextEditingController();
  final hqController = TextEditingController();
  final mobileController = TextEditingController();

  String? selectedDesignation;
  String? selectedStaffCategory;
  String? selectedPayLevel;

  final designations = [
    'Loco Pilot',
    'Assistant Loco Pilot',
    'Guard',
    'TC / TTE',
    'RPF Constable',
    'RPF Head Constable',
    'RPF ASI',
    'RPF SI',
    'Other',
  ];

  final staffCategories = [
    'Running Staff',
    'Commercial Staff',
    'RPF',
    'Station Staff',
    'Engineering Staff',
    'Other Railway Staff',
  ];

  final payLevels = [
    'Level 1',
    'Level 2',
    'Level 3',
    'Level 4',
    'Level 5',
    'Level 6',
    'Level 7',
    'Level 8',
    'Level 9',
    'Level 10',
    'Level 11',
    'Level 12',
    'Level 13',
    'Level 14',
    'Level 15',
    'Level 16',
    'Level 17',
    'Level 18',
  ];

  @override
  void initState() {
  super.initState();
  loadProfile();
}
Future<void> loadProfile() async {
  final profile = await _storageService.loadProfile();

  if (!mounted) return;

  setState(() {
    nameController.text =
        profile[EmployeeStorageService.nameKey] ?? '';

    employeeIdController.text =
        profile[EmployeeStorageService.employeeIdKey] ?? '';

    departmentController.text =
        profile[EmployeeStorageService.departmentKey] ?? '';

    zoneController.text =
        profile[EmployeeStorageService.zoneKey] ?? '';

    hqController.text =
        profile[EmployeeStorageService.hqKey] ?? '';

    mobileController.text =
        profile[EmployeeStorageService.mobileKey] ?? '';

    final savedCategory =
        profile[EmployeeStorageService.staffCategoryKey] ?? '';

    if (staffCategories.contains(savedCategory)) {
      selectedStaffCategory = savedCategory;
    }

    final savedDesignation =
        profile[EmployeeStorageService.designationKey] ?? '';

    if (designations.contains(savedDesignation)) {
      selectedDesignation = savedDesignation;
    }

    final savedPayLevel =
        profile[EmployeeStorageService.payLevelKey] ?? '';

    if (payLevels.contains(savedPayLevel)) {
      selectedPayLevel = savedPayLevel;
    }
  });
}
  @override
  void dispose() {
    nameController.dispose();
    employeeIdController.dispose();
    departmentController.dispose();
    zoneController.dispose();
    hqController.dispose();
    mobileController.dispose();
    super.dispose();
  }

 Future<void> saveProfile() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  await _storageService.saveProfile(
    name: nameController.text.trim(),
    employeeId: employeeIdController.text.trim(),
    staffCategory: selectedStaffCategory ?? '',
    designation: selectedDesignation ?? '',
    payLevel: selectedPayLevel ?? '',
    department: departmentController.text.trim(),
    zone: zoneController.text.trim(),
    hq: hqController.text.trim(),
    mobile: mobileController.text.trim(),
  );

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'Employee profile saved successfully.',
      ),
    ),
  );
}

  InputDecoration fieldDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 850,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Employee Information',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Enter your Railway employee details. '
                      'These details can be used later for duty '
                      'records and PDF reports.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 24),

                    TextFormField(
                      controller: nameController,
                      decoration: fieldDecoration(
                        'Employee Name',
                        Icons.person_outline,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter employee name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: employeeIdController,
                      decoration: fieldDecoration(
                        'Employee ID',
                        Icons.badge_outlined,
                      ),
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      initialValue: selectedStaffCategory,
                      decoration: fieldDecoration(
                        'Staff Category',
                        Icons.groups_outlined,
                      ),
                      items: staffCategories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStaffCategory = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      initialValue: selectedDesignation,
                      decoration: fieldDecoration(
                        'Designation',
                        Icons.work_outline,
                      ),
                      items: designations.map((designation) {
                        return DropdownMenuItem(
                          value: designation,
                          child: Text(designation),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDesignation = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      initialValue: selectedPayLevel,
                      decoration: fieldDecoration(
                        'Pay Level',
                        Icons.currency_rupee,
                      ),
                      items: payLevels.map((level) {
                        return DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPayLevel = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: departmentController,
                      decoration: fieldDecoration(
                        'Department',
                        Icons.account_balance_outlined,
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: zoneController,
                      decoration: fieldDecoration(
                        'Railway Zone',
                        Icons.map_outlined,
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: hqController,
                      decoration: fieldDecoration(
                        'Headquarters / HQ',
                        Icons.location_on_outlined,
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: fieldDecoration(
                        'Mobile Number',
                        Icons.phone_outlined,
                      ),
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: saveProfile,
                        icon: const Icon(Icons.save_outlined),
                        label: const Text(
                          'Save Employee Profile',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Note: Profile information will later be '
                      'stored locally and reused for monthly duty '
                      'and PDF reports.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}