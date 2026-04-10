
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../services/database_service.dart';
import '../models/employee_model.dart';
import '../models/attendance_model.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  final int employeeId;

  const EmployeeDetailsScreen({super.key, required this.employeeId});

  @override
  _EmployeeDetailsScreenState createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  late Future<Employee?> _employee;
  late Future<List<Attendance>> _attendanceRecords;

  @override
  void initState() {
    super.initState();
    _employee = _getEmployeeDetails();
    _attendanceRecords = _getAttendanceRecords();
  }

  Future<Employee?> _getEmployeeDetails() async {
    final db = await DatabaseService.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query('employees', where: 'id = ?', whereArgs: [widget.employeeId]);
    if (maps.isNotEmpty) {
      return Employee.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Attendance>> _getAttendanceRecords() async {
    final db = await DatabaseService.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'attendance',
      where: 'employee_id = ?',
      whereArgs: [widget.employeeId],
      orderBy: 'timestamp DESC',
    );
    return List.generate(maps.length, (i) {
      return Attendance.fromMap(maps[i]);
    });
  }

  Future<void> _authenticateAndMarkAttendance(String type) async {
    bool authenticated = false;
    try {
      authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to mark attendance',
      );
    } catch (e) {
      print(e);
    }

    if (authenticated) {
      final db = await DatabaseService.instance.database;
      final attendance = Attendance(
        employeeId: widget.employeeId,
        timestamp: DateTime.now(),
        type: type,
      );
      await db.insert('attendance', attendance.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance marked as $type successfully!')),
      );
      setState(() {
        _attendanceRecords = _getAttendanceRecords();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Employee?>(
          future: _employee,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return Text(snapshot.data!.name);
            } else {
              return const Text('Employee Details');
            }
          },
        ),
      ),
      body: FutureBuilder<Employee?>(
        future: _employee,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Employee not found.'));
          } else {
            final employee = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (employee.photoPath != null)
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(File(employee.photoPath!)),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(employee.name, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _authenticateAndMarkAttendance('check-in'),
                        child: const Text('Check In'),
                      ),
                      ElevatedButton(
                        onPressed: () => _authenticateAndMarkAttendance('check-out'),
                        child: const Text('Check Out'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Attendance History', style: Theme.of(context).textTheme.titleMedium),
                  Expanded(
                    child: FutureBuilder<List<Attendance>>(
                      future: _attendanceRecords,
                      builder: (context, attendanceSnapshot) {
                        if (attendanceSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (attendanceSnapshot.hasError) {
                          return Center(child: Text('Error: ${attendanceSnapshot.error}'));
                        } else if (!attendanceSnapshot.hasData || attendanceSnapshot.data!.isEmpty) {
                          return const Center(child: Text('No attendance records found.'));
                        } else {
                          final records = attendanceSnapshot.data!;
                          return ListView.builder(
                            itemCount: records.length,
                            itemBuilder: (context, index) {
                              final record = records[index];
                              return ListTile(
                                title: Text('${record.type} at ${record.timestamp}'),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
