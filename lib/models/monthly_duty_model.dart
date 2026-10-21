class MonthlyDuty {
  final String id;
  final String monthId;

  final DateTime date;

  final String dutyType;

  final String fromStation;
  final String toStation;

  final String startTime;
  final String endTime;

  final String trainNumber;
  final String trainName;

  final double ta;
  final double da;

  final String remarks;

  MonthlyDuty({
    required this.id,
    required this.monthId,
    required this.date,
    required this.dutyType,
    required this.fromStation,
    required this.toStation,
    required this.startTime,
    required this.endTime,
    required this.trainNumber,
    required this.trainName,
    required this.ta,
    required this.da,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'monthId': monthId,
      'date': date.toIso8601String(),
      'dutyType': dutyType,
      'fromStation': fromStation,
      'toStation': toStation,
      'startTime': startTime,
      'endTime': endTime,
      'trainNumber': trainNumber,
      'trainName': trainName,
      'ta': ta,
      'da': da,
      'remarks': remarks,
    };
  }

  factory MonthlyDuty.fromMap(Map<String, dynamic> map) {
    return MonthlyDuty(
      id: map['id'] as String,
      monthId: map['monthId'] as String,
      date: DateTime.parse(map['date'] as String),
      dutyType: map['dutyType'] as String,
      fromStation: map['fromStation'] as String,
      toStation: map['toStation'] as String,
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
      trainNumber: map['trainNumber'] as String,
      trainName: map['trainName'] as String,
      ta: (map['ta'] as num).toDouble(),
      da: (map['da'] as num).toDouble(),
      remarks: map['remarks'] as String,
    );
  }
}

