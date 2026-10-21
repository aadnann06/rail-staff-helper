import 'package:flutter/material.dart';

import '../models/duty_month_model.dart';
import '../services/duty_month_storage_service.dart';
import 'add_duty_screen.dart';

class MonthlyDutyScreen extends StatefulWidget {
  const MonthlyDutyScreen({super.key});

  @override
  State<MonthlyDutyScreen> createState() => _MonthlyDutyScreenState();
}

class _MonthlyDutyScreenState extends State<MonthlyDutyScreen> {
  final DutyMonthStorageService _storageService =
      DutyMonthStorageService();

  List<DutyMonth> _months = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMonths();
  }

  Future<void> _loadMonths() async {
    final months = await _storageService.getMonths();

    if (!mounted) {
      return;
    }

    setState(() {
      _months = months;
      _isLoading = false;
    });
  }

  Future<void> _createNewMonth() async {
    final now = DateTime.now();

    int selectedMonth = now.month;
    int selectedYear = now.year;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Create New Month'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    initialValue: selectedMonth,
                    decoration: const InputDecoration(
                      labelText: 'Month',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(
                      12,
                      (index) {
                        final monthNumber = index + 1;

                        return DropdownMenuItem<int>(
                          value: monthNumber,
                          child: Text(
                            _monthName(monthNumber),
                          ),
                        );
                      },
                    ),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setDialogState(() {
                        selectedMonth = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    initialValue: selectedYear,
                    decoration: const InputDecoration(
                      labelText: 'Year',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(
                      11,
                      (index) {
                        final year = now.year - 5 + index;

                        return DropdownMenuItem<int>(
                          value: year,
                          child: Text(year.toString()),
                        );
                      },
                    ),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setDialogState(() {
                        selectedYear = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final newMonth = DutyMonth(
                      id: DateTime.now()
                          .microsecondsSinceEpoch
                          .toString(),
                      month: selectedMonth,
                      year: selectedYear,
                    );

                    final added = await _storageService.addMonth(
                      newMonth,
                    );

                    if (!dialogContext.mounted) {
                      return;
                    }

                    Navigator.pop(dialogContext, added);

                    if (!added) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'This month already exists.',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true) {
      await _loadMonths();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Month created successfully.'),
        ),
      );
    }
  }

  Future<void> _deleteMonth(DutyMonth month) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Month?'),
          content: Text(
            'Do you want to delete ${month.displayName}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await _storageService.deleteMonth(month.id);

    await _loadMonths();
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Duty'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _months.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 70,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No months created yet',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Create a month to start adding duties.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _createNewMonth,
                          icon: const Icon(Icons.add),
                          label: const Text('Create New Month'),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _months.length,
                  itemBuilder: (context, index) {
                    final month = _months[index];

                    return Card(
                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(
                            Icons.calendar_month,
                          ),
                        ),
                        title: Text(
                          month.displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text(
                          '0 Duties',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            _deleteMonth(month);
                          },
                        ),
                       onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddDutyScreen(
        monthId: month.id,
        monthName: month.displayName,
      ),
    ),
  );
},
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewMonth,
        icon: const Icon(Icons.add),
        label: const Text('New Month'),
      ),
    );
  }
}