class DutyMonth {
  final String id;
  final int month;
  final int year;

  DutyMonth({
    required this.id,
    required this.month,
    required this.year,
  });

  String get monthName {
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

  String get displayName => '$monthName $year';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'month': month,
      'year': year,
    };
  }

  factory DutyMonth.fromMap(Map<String, dynamic> map) {
    return DutyMonth(
      id: map['id'] as String,
      month: map['month'] as int,
      year: map['year'] as int,
    );
  }
}