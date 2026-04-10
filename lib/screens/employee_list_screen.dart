
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/database_service.dart';
import '../models/employee_model.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  late Future<List<Employee>> _employees;

  @override
  void initState() {
    super.initState();
    _refreshEmployeeList();
  }

  void _refreshEmployeeList() {
    setState(() {
      _employees = _getEmployees();
    });
  }

  Future<List<Employee>> _getEmployees() async {
    final db = await DatabaseService.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('employees');
    return List.generate(maps.length, (i) {
      return Employee.fromMap(maps[i]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
      ),
      body: FutureBuilder<List<Employee>>(
        future: _employees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No employees found.'));
          } else {
            final employees = snapshot.data!;
            return ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(employee.name.substring(0, 1)),
                    ),
                    title: Text(employee.name),
                    onTap: () => context.go('/employees/${employee.id}'),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add_employee'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
