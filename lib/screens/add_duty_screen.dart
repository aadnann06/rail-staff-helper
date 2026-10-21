import 'package:flutter/material.dart';

import '../models/monthly_duty_model.dart';
import '../services/monthly_duty_storage_service.dart';

class AddDutyScreen extends StatefulWidget {
  final String monthId;
  final String monthName;

  const AddDutyScreen({
    super.key,
    required this.monthId,
    required this.monthName,
  });

  @override
  State<AddDutyScreen> createState() => _AddDutyScreenState();
}

class _AddDutyScreenState extends State<AddDutyScreen> {
  final _formKey = GlobalKey<FormState>();

  final MonthlyDutyStorageService _storageService =
      MonthlyDutyStorageService();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  String? _selectedDutyType;

  final TextEditingController _fromStationController =
      TextEditingController();

  final TextEditingController _toStationController =
      TextEditingController();
      final TextEditingController _trainNumberController =
    TextEditingController();

final TextEditingController _trainNameController =
    TextEditingController();

final TextEditingController _remarksController =
    TextEditingController();

  final List<String> _dutyTypes = [
    'Running Duty',
    'Shunting Duty',
    'Training',
    'Office Duty',
    'Other',
  ];

  @override
  
void dispose() {
  _fromStationController.dispose();
  _toStationController.dispose();
  _trainNumberController.dispose();
  _trainNameController.dispose();
  _remarksController.dispose();
  super.dispose();
}

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<void> _selectStartTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );

    if (pickedTime == null) {
      return;
    }

    setState(() {
      _startTime = pickedTime;
    });
  }

  Future<void> _selectEndTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );

    if (pickedTime == null) {
      return;
    }

    setState(() {
      _endTime = pickedTime;
    });
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) {
      return 'Select Time';
    }

    return time.format(context);
  }

  Future<void> _saveDuty() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select start and end time.'),
        ),
      );
      return;
    }

   final duty = MonthlyDuty(
  id: DateTime.now().microsecondsSinceEpoch.toString(),
  monthId: widget.monthId,
  date: _selectedDate,
  dutyType: _selectedDutyType!,
  fromStation: _fromStationController.text.trim(),
  toStation: _toStationController.text.trim(),
  startTime: _formatTime(_startTime),
  endTime: _formatTime(_endTime),
  trainNumber: _trainNumberController.text.trim(),
  trainName: _trainNameController.text.trim(),
  ta: 0.0,
  da: 0.0,
  remarks: _remarksController.text.trim(),
);

    await _storageService.addDuty(duty);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Duty saved successfully.'),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Duty - ${widget.monthName}'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Duty Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  widget.monthName,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Duty Date',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),
                const SizedBox(height: 18),

TextFormField(
  controller: _trainNumberController,
  decoration: const InputDecoration(
    labelText: 'Train Number',
    hintText: 'e.g. 12140',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.train),
  ),
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter train number';
    }

    return null;
  },
),

const SizedBox(height: 18),

TextFormField(
  controller: _trainNameController,
  decoration: const InputDecoration(
    labelText: 'Train Name',
    hintText: 'e.g. Sewagram Express',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.directions_railway),
  ),
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter train name';
    }

    return null;
  },
),

                InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      '${_selectedDate.day.toString().padLeft(2, '0')}/'
                      '${_selectedDate.month.toString().padLeft(2, '0')}/'
                      '${_selectedDate.year}',
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                DropdownButtonFormField<String>(
                  initialValue: _selectedDutyType,
                  decoration: const InputDecoration(
                    labelText: 'Duty Type',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                  items: _dutyTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDutyType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select duty type';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                TextFormField(
                  controller: _fromStationController,
                  decoration: const InputDecoration(
                    labelText: 'From Station',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.trip_origin),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter starting station';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                TextFormField(
                  controller: _toStationController,
                  decoration: const InputDecoration(
                    labelText: 'To Station',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter destination station';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                InkWell(
                  onTap: _selectStartTime,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Start Time',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.login),
                    ),
                    child: Text(
                      _formatTime(_startTime),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                InkWell(
                  onTap: _selectEndTime,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'End Time',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.logout),
                    ),
                    child: Text(
                      _formatTime(_endTime),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const SizedBox(height: 18),

TextFormField(
  controller: _remarksController,
  maxLines: 3,
  decoration: const InputDecoration(
    labelText: 'Remarks',
    hintText: 'Enter any additional duty details',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.notes),
    alignLabelWithHint: true,
  ),
),

const SizedBox(height: 24),



                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TA / DA',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 14),

                        const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text('TA'),
                            Text(
                              '₹0.00',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text('DA'),
                            Text(
                              '₹0.00',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const Divider(height: 24),

                        const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹0.00',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'TA/DA will be calculated automatically '
                          'after the applicable Railway rules are configured.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _saveDuty,
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'Save Duty',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}