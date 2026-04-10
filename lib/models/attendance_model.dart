
class Attendance {
  final int? id;
  final int employeeId;
  final DateTime timestamp;
  final String type;

  Attendance({
    this.id,
    required this.employeeId,
    required this.timestamp,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employee_id': employeeId,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      employeeId: map['employee_id'],
      timestamp: DateTime.parse(map['timestamp']),
      type: map['type'],
    );
  }
}
